# Beautiful Bend

A small, source-grounded skill that teaches AI assistants to write clear,
idiomatic **Bend 2**: explicit ownership, structural recursion, useful types,
pure computation, and laws backed by checked proofs.

**Start with [the skill](skills/bend-best-practices/SKILL.md),
[the 100-case matrix](COVERAGE.md), or
[the validation record](VALIDATION.md).**

This version targets **Bend 2.0.39**, from the implementation linked by
[bend-lang.com](https://bend-lang.com/). It does not target the older
HigherOrderCO/HVM-based Bend. The source commit and supporting tools are pinned
in [toolchain.json](toolchain.json); do not silently apply the guidance to
another generation. The skill checks language identity before giving advice.

## Try it locally

Clone `https://github.com/codingleo/beautiful-bend.git`. The repository contains
the complete skill; no package publication is required.

**Codex:** copy the complete skill directory into your Bend project's
`.agents/skills/` (keep its references, examples and license files together):

```sh
# Run from the beautiful-bend checkout; choose your project's path.
mkdir -p /path/to/your-project/.agents/skills
cp -R skills/bend-best-practices /path/to/your-project/.agents/skills/
```

Then ask: `Use $bend-best-practices to review this Bend module.` For personal
installation, use `~/.agents/skills/` instead. See the official
[Codex skill discovery documentation](https://learn.chatgpt.com/docs/build-skills).
Avoid copying over an existing customized installation without reviewing it.

**Claude Code:** load the repository as a local plugin:

```sh
claude --plugin-dir /path/to/beautiful-bend
```

Invoke `/beautiful-bend:bend-best-practices`, or ask for a Bend task. The
[plugin](.claude-plugin/plugin.json) and [marketplace](.claude-plugin/marketplace.json)
manifests use the standard `skills/` layout. Optional persistent local setup:
`/plugin marketplace add /path/to/beautiful-bend`, then
`/plugin install beautiful-bend@beautiful-bend`. See
[Claude's plugin documentation](https://code.claude.com/docs/en/plugins/create).
See [the host smoke record](VALIDATION.md#host-smoke-and-untested-layers) for
observed CLI results and loading limitations.

**Other assistants:** supply `skills/bend-best-practices/SKILL.md` and its sibling
resources explicitly. No hooks, external services, or model credentials are
required by the skill itself.

## Use the Bend workflow

Install Bend using the instructions on [the official site](https://bend-lang.com/).
Review its installer before executing it. This project's setup does not run it
automatically. Check `bend version`, then read `bend guide` and `bend base NAME`.

A suggested addition to a Bend project's `AGENTS.md` is:

```text
When using Bend:
- Confirm the compiler version and run `bend guide`.
- Keep important requirements in `LAWS.bend`; preserve existing laws unless
  the user requests a specification change.
- Run `bend PROOF.bend` before committing and require a passing verdict.
- Consider parallel calls for independent, balanced work; measure on the target.
```

This follows the site's guide/laws/proofs/parallelism workflow while making
verification and performance limits explicit. A law only expresses the property
written down. Ordinary checker acceptance, BendTT kernel verification, runtime
tests and speed measurements are different evidence.

Example requests:

- “Refactor this parser into small pure functions; preserve its error behavior.”
- “Fix this affine-use error without weakening the types or laws.”
- “Prove this counter law, then show which checks you ran.”
- “Review this tree split for parallel execution; avoid unmeasured speed claims.”

## What is included

The entry point routes to focused references; complete examples stay outside the
always-loaded instructions. **100 distinct cases** include the original 17 cases
and 83 new ones:

- **15 law/proof projects, 19 law declarations:** finite state invariants,
  Nat/list/tree induction, roundtrips, equality transport and existential witnesses.
  Each has a fixed specification, implementation, proof and targeted rejecting
  mutation. The 13 mutated implementations must remain valid Bend programs.
- **60 runtime programs:** typed domain models, callback quantities, checked
  arithmetic, parsing/error policies, text/collections, array ownership, IO,
  structural state machines and sequential references for parallel decomposition.
- **25 expected rejections:** ownership, erasure, matching/termination, templates,
  false/open proofs, and unsafe/foreign dependency guards.

The [coverage matrix](COVERAGE.md) records every contract and independent oracle.
Support files, 15 fixed-law mutations, two additional proof-integrity checks,
validator unit tests and [agent evaluations](evals/README.md) are separate from
the 100-case count. Tests execute locally in this cloud workspace and in CI.

Laws drive the proof projects. For example,
[batch length](skills/bend-best-practices/examples/suite/proofs/replicate_length/LAWS.bend)
quantifies over every Nat count; its inductive proof shows that the produced list
contains exactly that many units. A mutant that omits units remains well-typed
but fails the unchanged law. Conversely, map length preservation does **not**
prove payload correctness. Read the [contract limits](tests/findings/proof-mutations.md)
before generalizing any claim. Both ordinary checker acceptance and independent
BendTT verification of these 15 proof projects are recorded separately in
[the validation record](VALIDATION.md). The kernel result covers the 19 stated
laws; it does not prove the behavior of all 100 cases.

```text
.claude-plugin/                  local plugin and marketplace metadata
skills/bend-best-practices/      self-contained installable skill
  SKILL.md                      workflow and reference routing
  agents/openai.yaml            Codex display metadata
  references/                   focused guidance and provenance
  examples/                     60 runtime programs and 15 law/proof projects
tests/                          contracts, exact outputs, rejections, mutations, findings
evals/                          model tasks, inputs, rubrics, recorded evidence
scripts/validate.py             offline structure and compiler/runtime checks
```

## Validate and contribute

Use Node **24.x**, Python 3.12, npm and Git. The setup installs locked Bun tooling
and fetches the exact Bend revision into a new directory you own:

```sh
python3 scripts/coverage.py --check
python3 scripts/validate.py --structure-only
python3 -m unittest discover -s tests -v
python3 scripts/setup_toolchain.py --directory /tmp/beautiful-bend-tools --report .validation/setup.json
python3 scripts/validate.py --bend /tmp/beautiful-bend-tools/bin/bend --report .validation/results.json
```

Choose an unused setup directory; the script refuses to reset existing work.
It needs network access and does not execute the website installer. Full mode
requires exactly Bend 2.0.39 and stable Node 24.x; it fails on missing or wrong
tools. `--case p06` selects a labeled development subset. `--native` additionally
builds/runs the 60 programs on the CPU (clang 14+); this backend remains untested.

On Linux x86_64, add `--kernel` to setup to download the SHA256-pinned Lean 4.34.0
archive and build BendTT from the same Bend revision. Then run:

```sh
python3 scripts/validate_kernel.py --bend /tmp/beautiful-bend-tools/bin/bend --kernel /tmp/beautiful-bend-tools/bin/bendtt --report .validation/kernel.json
```

This separate runner checks all 15 proof projects and direct valid/invalid kernel
controls. See [CONTRIBUTING.md](CONTRIBUTING.md) for prerequisites, failure handling
and development steps, [COMPATIBILITY.md](COMPATIBILITY.md) for supported targets,
and [VALIDATION.md](VALIDATION.md) for observed results and limits.

[CI](https://github.com/codingleo/beautiful-bend/actions) has distinct **`check`**
and **`BendTT kernel`** jobs. It retains named JSON reports for **14 days**, including
failed runs when reports exist. It does not publish anything. Questions and bugs
use [support](SUPPORT.md); sensitive findings use [security reporting](SECURITY.md).
Contributors follow the [code of conduct](CODE_OF_CONDUCT.md). Maintainers have a
[settings checklist](docs/MAINTAINER_CHECKLIST.md) and [release guide](docs/RELEASING.md).

## Provenance and license

Inspired by [BeautifulRust](https://github.com/morganlinton/BeautifulRust) by
Morgan Linton: one discoverable skill, focused references, explicit checks and
realistic evaluations. Bend's guidance and examples are original and based on
its own primary documentation and implementation; Rust-only rules are not ported.
See [pinned sources](skills/bend-best-practices/references/sources.md) and
[third-party attribution](skills/bend-best-practices/THIRD_PARTY_NOTICES.md).

MIT, copyright 2026 Leonardo Ribeiro. See [LICENSE](LICENSE). This is an
independent community project, not an official Bend language specification.
