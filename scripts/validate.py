#!/usr/bin/env python3
"""Check the 100-case corpus with Python stdlib, pinned Bend, and Node.

Structure-only is explicit. Full mode records every attempted command and
continues independent cases after a failure. These checks are not a host plugin
schema validator, a proof of compiler correctness, or a performance benchmark.
"""

import argparse
from collections import Counter
from datetime import datetime, timezone
import hashlib
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
EXPECTED_COUNTS = {"run": 60, "proof": 15, "reject": 25}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(path.read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def local_file(root, name):
    path = Path(name)
    require(not path.is_absolute() and ".." not in path.parts, f"Not a repository-relative path: {name}")
    require((root / path).is_file(), f"Missing fixture: {name}")
    return root / path


def validate_manifest(manifest, root=ROOT):
    require(manifest.get("schema_version") == 2, "Expected corpus schema_version 2")
    cases = manifest["cases"]
    require(Counter(c["kind"] for c in cases) == EXPECTED_COUNTS,
            f"Expected exactly {EXPECTED_COUNTS}; cases must not silently disappear")
    ids = [c["id"] for c in cases]
    expected_ids = {f"{prefix}{i:02}" for prefix, count in (("r", 60), ("p", 15), ("n", 25))
                    for i in range(1, count + 1)}
    require(len(ids) == len(set(ids)) and set(ids) == expected_ids, "Case IDs must be r01..r60, p01..p15, n01..n25")
    entries = [c["file"] for c in cases]
    require(len(entries) == len(set(entries)), "Case entries must be distinct files")
    support = manifest["support"]
    require(len(support) == len(set(support)) and not set(entries).intersection(support),
            "Support files must be unique and not counted as cases")
    for case in cases:
        require(case['id'].startswith({'run': 'r', 'proof': 'p', 'reject': 'n'}[case['kind']]),
                f'{case["id"]}: ID prefix must agree with kind')
        local_file(root, case["file"])
        for field in ("purpose", "oracle", "category"):
            require(isinstance(case.get(field), str) and case[field].strip(), f'{case["id"]}: missing {field}')
        if case["kind"] == "run":
            require(isinstance(case.get("stdout"), str), f'{case["id"]}: missing output oracle')
            require(isinstance(case.get("normalize"), bool), f'{case["id"]}: missing normalization policy')
        elif case["kind"] == "reject":
            require(isinstance(case.get("diagnostic"), str) and len(case["diagnostic"]) >= 8,
                    f'{case["id"]}: diagnostic must distinguish a relevant compiler failure')
        else:
            law = local_file(root, case["law_file"])
            require(digest(law) == case["law_sha256"], f'{case["id"]}: law specification changed')
            require(law.name == "LAWS.bend" and Path(case["file"]).name == "PROOF.bend",
                    f'{case["id"]}: use the standard laws/proof entry layout')
            require(not re.search(r"^def main\b", (root / case["file"]).read_text(), re.M),
                    f'{case["id"]}: proof entry must not hide its verdict behind main')
    for name in support:
        local_file(root, name)
    corpus_files = {str(p.relative_to(root)) for area in
                    (root / "skills/bend-best-practices/examples", root / "tests/negative")
                    for p in area.rglob("*.bend")}
    accounted_bend = {name for name in entries + support if name.endswith('.bend')}
    require(accounted_bend == corpus_files, "Every corpus .bend file must be an entry or support file")
    return cases


def structure():
    text = (SKILL / "SKILL.md").read_text()
    # Enforce our deliberately small frontmatter format, not arbitrary YAML.
    match = re.match(r"\A---\nname: ([a-z0-9-]+)\ndescription: >-\n((?:  .+\n)+)---\n", text)
    require(match is not None, "Invalid skill frontmatter")
    require(match[1] == SKILL.name and len(match[2]) <= 1024, "Invalid skill name/description")
    require(len(text.splitlines()) <= 150, "Keep the entry point under 150 lines")
    require((SKILL / "LICENSE").read_bytes() == (ROOT / "LICENSE").read_bytes(), "Standalone license differs")
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
    require(market["plugins"][0]["name"] == plugin["name"] and market["plugins"][0]["source"] == "./",
            "Marketplace must load the local plugin root")
    for doc in ROOT.rglob("*.md"):
        if ".git" in doc.parts or ".validation" in doc.parts:
            continue
        for target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", doc.read_text()):
            if re.match(r"[a-z]+://|#|mailto:", target):
                continue
            require((doc.parent / target.split("#")[0]).exists(),
                    f"Broken local link: {doc.relative_to(ROOT)} -> {target}")
    cases = validate_manifest(read_json(ROOT / "tests/cases.json"))
    validate_mutations(read_json(ROOT / "tests/proof-mutations.json"), cases)
    evals = read_json(ROOT / "evals/cases.json")
    ids = [case["id"] for case in evals]
    require(len(ids) == len(set(ids)), "Duplicate agent eval IDs")
    for case in evals:
        require(case["prompt"] and len(case["rubric"]) >= 3, "Incomplete agent eval")
        for item in case.get("inputs", []):
            local_file(ROOT / "evals", item)
    return cases


def validate_mutations(manifest, cases, root=ROOT):
    mutations = manifest['mutations']
    proofs = {c['id']: c for c in cases if c['kind'] == 'proof'}
    require({m['id'] for m in mutations} == {f'm{i:02}' for i in range(1, 16)}
            and len(mutations) == 15, 'Require exactly 15 distinct proof mutations')
    require({m['proof_case'] for m in mutations} == set(proofs), 'Every proof needs a mutation')
    for mutation in mutations:
        case = proofs[mutation['proof_case']]
        target = local_file(root, mutation['file'])
        require(target.parent == (root / case['file']).parent and target.name != 'LAWS.bend',
                'Mutation must stay in its proof project and preserve LAWS')
        require(mutation['old'] and mutation['old'] != mutation['new']
                and target.read_text().count(mutation['old']) == 1, 'Mutation target must be unique and change behavior')
        require(mutation['purpose'] and len(mutation['diagnostic']) >= 8, 'Mutation needs purpose and diagnostic')
    return mutations


def assess(result, *, stdout=None, verdict=False, diagnostic=None):
    """Never count a missing tool, crash or unrelated error as a rejection pass."""
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


class Runner:
    def __init__(self, report):
        self.report = report

    def run(self, label, command, **expect):
        entry = {"name": label, "command": command, "expect": expect, "status": "failed"}
        self.report["checks"].append(entry)
        try:
            result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, timeout=60,
                                    env={**os.environ, "BEND_NO_TELEMETRY": "1"})
            entry.update(exit=result.returncode, stdout=result.stdout, stderr=result.stderr)
            assess(result, **expect)
            entry["status"] = "passed"
            return True
        except (ValueError, OSError, subprocess.TimeoutExpired) as error:
            entry["error"] = str(error)
            print(f"FAIL {label}: {error}", file=sys.stderr, flush=True)
            return False


def exercise(case, args, runner, temp):
    source = str(ROOT / case["file"])
    label = case["id"]
    if case["kind"] == "reject":
        return runner.run(label + " rejection", [args.bend, source, "--check-only"], diagnostic=case["diagnostic"])
    if not runner.run(label + " check", [args.bend, source, "--check-only"], verdict=True):
        return False
    if case["kind"] == "proof":
        ok = runner.run(label + " proof gate", [args.bend, source], verdict=True)
        if args.verdict:
            ok = runner.run(label + " kernel", [args.bend, source, "--verdict"], verdict=True) and ok
        return ok
    ok = True
    if case["normalize"]:
        ok = runner.run(label + " normalize", [args.bend, source], stdout=case["stdout"])
    js = str(temp / (label + ".js"))
    emitted = runner.run(label + " emit JS", [args.bend, source, "-o", js])
    ok = emitted and ok
    if emitted:
        ok = runner.run(label + " execute JS", [args.node, js], stdout=case["stdout"]) and ok
    if args.native:
        binary = str(temp / label)
        built = runner.run(label + " build native", [args.bend, source, "-o", binary])
        ok = built and ok
        if built:
            ok = runner.run(label + " execute native", [binary], stdout=case["stdout"]) and ok
    return ok


def mutation_checks(args, runner, temp, cases):
    proofs = {case['id']: case for case in cases if case['kind'] == 'proof'}
    ok = True
    for mutation in validate_mutations(read_json(ROOT / 'tests/proof-mutations.json'), cases):
        case = proofs[mutation['proof_case']]
        project = (ROOT / case['file']).parent
        copied = temp / mutation['id']
        shutil.copytree(project, copied)
        target = copied / Path(mutation['file']).name
        target.write_text(target.read_text().replace(mutation['old'], mutation['new']))
        require((copied / 'LAWS.bend').read_bytes() == (ROOT / case['law_file']).read_bytes(),
                'Mutation changed LAWS')
        # An implementation defect must still be valid Bend; syntax failures do
        # not demonstrate that a law caught incorrect behavior.
        if target.name != 'PROOF.bend':
            ok = runner.run(mutation['id'] + ' valid mutated model',
                            [args.bend, str(target), '--check-only'], verdict=True) and ok
        ok = runner.run(mutation['id'] + ' fixed-law rejection',
                        [args.bend, str(copied / 'PROOF.bend'), '--check-only'],
                        diagnostic=mutation['diagnostic']) and ok
    mutated = temp / "mutated"
    shutil.copytree(EXAMPLES / "laws", mutated)
    counter = mutated / "counter.bend"
    original = counter.read_text()
    needle = "1n+credit(rest, balance)"
    require(original.count(needle) == 1, "Mutation target changed; review the proof guard")
    counter.write_text(original.replace(needle, "2n+credit(rest, balance)"))
    ok = runner.run("integrity: reject changed implementation", [args.bend, str(mutated / "PROOF.bend")],
                    diagnostic="expected") and ok
    counter.write_text(original)
    proof = mutated / "PROOF.bend"
    proof.write_text("import Base\n")
    return runner.run("integrity: reject missing law import", [args.bend, str(proof)],
                      diagnostic="PROOF.bend must import ./LAWS.bend") and ok


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--structure-only", action="store_true")
    parser.add_argument("--bend", default="bend", help="Executable path, not a shell command")
    parser.add_argument("--node", default="node")
    parser.add_argument("--native", action="store_true", help="Also build/run native CPU examples")
    parser.add_argument("--verdict", action="store_true", help="Also check all proof projects with BendTT")
    parser.add_argument("--case", action="append", default=[], help="Select IDs; repeat for several (not a full run)")
    parser.add_argument("--report", type=Path)
    args = parser.parse_args()
    report = {"status": "failed", "started_utc": datetime.now(timezone.utc).isoformat(),
              "scope": "structure" if args.structure_only else "subset" if args.case else "full-100",
              "checks": [], "cases": [], "skipped": [], "expected_toolchain": read_json(ROOT / "toolchain.json")}
    runner = Runner(report)
    try:
        cases = structure()
        print("PASS structure, links, metadata, all 100 cases and law hashes", flush=True)
        require(not (args.structure_only and (args.native or args.verdict or args.case)),
                "--structure-only cannot be combined with execution options")
        require(set(args.case) <= {c["id"] for c in cases}, "Unknown case ID")
        if args.structure_only:
            report["skipped"].append("All compiler/runtime/kernel checks (explicit structure-only mode)")
        else:
            version = report["expected_toolchain"]["bend_version"]
            require(runner.run("Bend version", [args.bend, "version"], stdout=f"bend {version}\n"), "Bend toolchain unavailable or wrong version")
            require(runner.run("Node version", [args.node, "--version"]), "Node unavailable")
            selected = [case for case in cases if not args.case or case["id"] in args.case]
            ok = True
            with tempfile.TemporaryDirectory(prefix="beautiful-bend-") as directory:
                temp = Path(directory)
                for case in selected:
                    passed = exercise(case, args, runner, temp)
                    report["cases"].append({"id": case["id"], "kind": case["kind"], "file": case["file"],
                                            "sha256": digest(ROOT / case["file"]), "status": "passed" if passed else "failed"})
                    print(f'{"PASS" if passed else "FAIL"} {case["id"]} {case["purpose"]}', flush=True)
                    ok = passed and ok
                if not args.case:
                    ok = mutation_checks(args, runner, temp, cases) and ok
                else:
                    report["skipped"].append("Unselected cases and corpus integrity mutations (subset mode)")
            if not args.verdict:
                report["skipped"].append("BendTT kernel (--verdict not requested)")
            if not args.native:
                report["skipped"].append("Native CPU compilation/execution (--native not requested)")
            report["skipped"].append("GPU execution, parallel scheduling and performance measurement")
            require(ok, "One or more corpus or integrity checks failed")
        report["status"] = "passed"
    except (ValueError, OSError, KeyError) as error:
        report["error"] = str(error)
        print(f"FAIL {error}", file=sys.stderr)
    finally:
        report["command_count"] = len(report["checks"])
        report["case_counts"] = {kind: dict(Counter(c["status"] for c in report["cases"] if c["kind"] == kind))
                                 for kind in EXPECTED_COUNTS}
        if args.report:
            args.report.parent.mkdir(parents=True, exist_ok=True)
            args.report.write_text(json.dumps(report, indent=2) + "\n")
    for item in report["skipped"]:
        print(f"SKIP {item}")
    print(f'{report["status"].upper()}: {len(report["cases"])} cases, {report["command_count"]} commands; scope={report["scope"]}')
    return 0 if report["status"] == "passed" else 1


if __name__ == "__main__":
    sys.exit(main())
