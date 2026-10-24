#!/usr/bin/env python3
"""Validate this repository; full mode requires the pinned Bend and Node.

Only Python's standard library is needed. Structural checks do not claim to be
an official Claude plugin schema validator or a general YAML parser.
"""

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "skills/bend-best-practices"
EXAMPLES = SKILL / "examples"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text())


def structure():
    text = (SKILL / "SKILL.md").read_text()
    # Deliberately enforce our small frontmatter format, not arbitrary YAML.
    match = re.match(r"\A---\nname: ([a-z0-9-]+)\ndescription: >-\n((?:  .+\n)+)---\n", text)
    require(match is not None, "Invalid skill frontmatter")
    require(match[1] == SKILL.name, "Skill name and directory disagree")
    require(len(match[2]) <= 1024, "Description exceeds 1024 characters")
    require(len(text.splitlines()) <= 150, "Keep the skill entry point under 150 lines")
    require((SKILL / "LICENSE").read_bytes() == (ROOT / "LICENSE").read_bytes(),
            "Standalone skill must carry the repository license")
    require((SKILL / "THIRD_PARTY_NOTICES.md").is_file(), "Missing attribution")
    metadata = (SKILL / "agents/openai.yaml").read_text()
    for key in ("display_name", "short_description", "default_prompt"):
        require(re.search(rf'^  {key}: "[^\n]+"$', metadata, re.M), f"Missing UI field {key}")
    require("$bend-best-practices" in metadata, "Default prompt must invoke the skill")

    plugin = read_json(ROOT / ".claude-plugin/plugin.json")
    market = read_json(ROOT / ".claude-plugin/marketplace.json")
    require(plugin["name"] == market["name"] == "beautiful-bend", "Plugin name mismatch")
    require(re.fullmatch(r"\d+\.\d+\.\d+", plugin["version"]), "Invalid plugin version")
    require(plugin["license"] == "MIT", "Plugin license mismatch")
    require(market["plugins"][0]["name"] == plugin["name"], "Marketplace entry mismatch")
    require(market["plugins"][0]["source"] == "./", "Marketplace must load local root")
    for doc in ROOT.rglob("*.md"):
        if ".git" in doc.parts or ".validation" in doc.parts:
            continue
        for target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", doc.read_text()):
            if re.match(r"[a-z]+://|#|mailto:", target):
                continue
            path = target.split("#")[0]
            require((doc.parent / path).exists(), f"Broken local link: {doc.relative_to(ROOT)} -> {target}")

    cases = read_json(ROOT / "tests/cases.json")
    files = [c["file"] for c in cases["runnable"]] + cases["support"]
    require(len(files) == len(set(files)), "Duplicate example coverage")
    require(set(files) == {str(p.relative_to(EXAMPLES)) for p in EXAMPLES.rglob("*.bend")},
            "Every example must be accounted for in cases.json")
    require({c["file"] for c in cases["negative"] if c["file"].startswith("tests/")}
            == {str(p.relative_to(ROOT)) for p in (ROOT / "tests/negative").rglob("*.bend")},
            "Every negative fixture must be covered")
    for case in cases["negative"]:
        require((ROOT / case["file"]).is_file() and case["diagnostic"], "Invalid negative fixture")
    evals = read_json(ROOT / "evals/cases.json")
    ids = [case["id"] for case in evals]
    require(len(ids) == len(set(ids)) and len(ids) >= 4, "Missing or duplicate eval cases")
    for case in evals:
        require(case["prompt"] and len(case["rubric"]) >= 3, "Incomplete eval case")
        for item in case.get("inputs", []):
            require((ROOT / "evals" / item).is_file(), f"Missing eval input: {item}")
    return cases


def assess(result, *, stdout=None, verdict=False, diagnostic=None):
    """Reject unrelated tool failures as well as wrong outputs and false greens."""
    combined = result.stdout + result.stderr
    if diagnostic is not None:
        require(result.returncode == 1, f"Expected compiler exit 1, got {result.returncode}: {combined}")
        require("SOME PROOFS FAIL" in combined and diagnostic in combined,
                f"Expected Bend rejection containing {diagnostic!r}: {combined}")
    else:
        require(result.returncode == 0, f"Command failed ({result.returncode}): {combined}")
        if verdict:
            require("ALL PROOFS CHECK" in result.stdout.splitlines(), f"Missing proof verdict: {combined}")
            require("SOME PROOFS FAIL" not in combined, f"Conflicting proof verdict: {combined}")
        if stdout is not None:
            require(result.stdout == stdout, f"Output mismatch: expected {stdout!r}, got {result.stdout!r}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--structure-only", action="store_true", help="Explicitly skip all Bend runs")
    parser.add_argument("--bend", default="bend", help="Executable path, not a shell command")
    parser.add_argument("--node", default="node", help="Node executable path")
    parser.add_argument("--native", action="store_true", help="Also compile and run native CPU examples")
    parser.add_argument("--verdict", action="store_true", help="Also run the BendTT kernel proof gate")
    parser.add_argument("--report", type=Path, help="Write machine-readable results")
    args = parser.parse_args()
    report = {"status": "failed", "checks": [], "skipped": []}

    def run(label, command, **expect):
        result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True,
                                timeout=60, env={**os.environ, "BEND_NO_TELEMETRY": "1"})
        entry = {"name": label, "command": command, "exit": result.returncode,
                 "stdout": result.stdout, "stderr": result.stderr}
        report["checks"].append(entry)
        assess(result, **expect)
        print(f"PASS {label}")
        return result

    try:
        cases = structure()
        print("PASS structure, links, metadata, fixture coverage")
        require(not (args.structure_only and (args.native or args.verdict)),
                "--structure-only cannot be combined with --native or --verdict")
        if args.structure_only:
            report["skipped"].append("All compiler, runtime and kernel checks (structure-only)")
        else:
            pin = read_json(ROOT / "toolchain.json")
            run("Bend version", [args.bend, "version"], stdout=f'bend {pin["bend_version"]}\n')
            run("Node version", [args.node, "--version"])
            all_examples = [c["file"] for c in cases["runnable"]] + cases["support"]
            for name in all_examples:
                if name != "laws/LAWS.bend":
                    run(f"check {name}", [args.bend, str(EXAMPLES / name), "--check-only"], verdict=True)
            with tempfile.TemporaryDirectory(prefix="beautiful-bend-") as directory:
                temp = Path(directory)
                for index, case in enumerate(cases["runnable"]):
                    source = str(EXAMPLES / case["file"])
                    if case["normalize"]:
                        run(f'normalize {case["file"]}', [args.bend, source], stdout=case["stdout"])
                    js = str(temp / f"example-{index}.js")
                    run(f'emit JS {case["file"]}', [args.bend, source, "-o", js])
                    run(f'run JS {case["file"]}', [args.node, js], stdout=case["stdout"])
                    if args.native:
                        binary = str(temp / f"example-{index}")
                        run(f'build native {case["file"]}', [args.bend, source, "-o", binary])
                        run(f'run native {case["file"]}', [binary], stdout=case["stdout"])
                for case in cases["negative"]:
                    run(f'reject {case["file"]}', [args.bend, str(ROOT / case["file"]), "--check-only"],
                        diagnostic=case["diagnostic"])
                # Verify the laws protect behavior, not merely a static proof file.
                mutated = temp / "mutated"
                shutil.copytree(EXAMPLES / "laws", mutated)
                counter = mutated / "counter.bend"
                counter.write_text(counter.read_text().replace("1n+credit(rest, balance)", "2n+credit(rest, balance)"))
                run("reject implementation mutation", [args.bend, str(mutated / "PROOF.bend")],
                    diagnostic="expected")
                shutil.copyfile(EXAMPLES / "laws/counter.bend", counter)
                proof = mutated / "PROOF.bend"
                proof.write_text("import Base\n")
                run("reject missing LAWS import", [args.bend, str(proof)],
                    diagnostic="PROOF.bend must import ./LAWS.bend")
            proof = str(EXAMPLES / "laws/PROOF.bend")
            run("proof gate", [args.bend, proof], verdict=True)
            if args.verdict:
                run("BendTT kernel", [args.bend, proof, "--verdict"], verdict=True)
            else:
                report["skipped"].append("BendTT kernel (--verdict not requested)")
            if not args.native:
                report["skipped"].append("Native CPU compilation/execution (--native not requested)")
            report["skipped"].append("GPU execution and performance measurement")
        report["status"] = "passed"
    except (ValueError, OSError, subprocess.TimeoutExpired) as error:
        report["error"] = str(error)
        print(f"FAIL {error}", file=sys.stderr)
    finally:
        if args.report:
            args.report.parent.mkdir(parents=True, exist_ok=True)
            args.report.write_text(json.dumps(report, indent=2) + "\n")
    for item in report["skipped"]:
        print(f"SKIP {item}")
    return 0 if report["status"] == "passed" else 1


if __name__ == "__main__":
    sys.exit(main())
