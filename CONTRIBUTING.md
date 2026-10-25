# Contributing

Follow the [code of conduct](CODE_OF_CONDUCT.md). For questions, use
[SUPPORT.md](SUPPORT.md); report sensitive findings through [SECURITY.md](SECURITY.md).

## Set up and propose a change

1. Fork the repository if you lack write access. Clone your fork, fetch current
   upstream main, and create a focused branch from it. Keep unrelated work separate.
2. Use Python 3.12, stable Node 24.x, npm and Git. Check out the repository and run
   the commands below from its root. Cold setup requires GitHub and npm access.
3. Edit the smallest relevant reference/example and add meaningful coverage when
   behavior changes. Preserve existing specifications and independent oracles.
4. Run affected checks, then the complete suite before requesting review. Include
   exact commands, outcomes and skips in the PR template. Open a draft PR for
   incomplete work; do not treat a skipped check as successful evidence.

```sh
python3 scripts/coverage.py --check
python3 scripts/validate.py --structure-only --report .validation/structure.json
python3 -m unittest discover -s tests -v
python3 scripts/setup_toolchain.py --directory /tmp/beautiful-bend-tools --report .validation/setup.json
python3 scripts/validate.py --bend /tmp/beautiful-bend-tools/bin/bend --report .validation/results.json
```

The setup directory must be new or empty. It copies the committed npm lockfile,
uses `npm ci`, verifies Bun/Node/Bend versions, and fetches the exact Bend commit.
Bun's npm installation runs its upstream installation script; review tooling
changes as executable dependencies. Nothing is installed globally and no website
installer is executed. On a failed setup, retain its JSON report and inspect the
cause before choosing a new directory; do not bypass denied access.

For the separate kernel gate on Linux x86_64, also have `curl`, `tar`, `zstd` and
a C compiler available. Use a new setup directory and add `--kernel` (the Lean
archive is about 580 MB; allow several GB for extraction/build):

```sh
python3 scripts/setup_toolchain.py --directory /tmp/beautiful-bend-kernel-tools --kernel --report .validation/kernel-setup.json
python3 scripts/validate_kernel.py --bend /tmp/beautiful-bend-kernel-tools/bin/bend --kernel /tmp/beautiful-bend-kernel-tools/bin/bendtt --report .validation/kernel.json
```

An already downloaded official archive can be supplied with `--lean-archive`;
its pinned SHA256 must still match. The script builds the kernel with the pinned
Lean toolchain, using Bend's supported `BENDTT` option without touching the home
directory. The independent kernel run has its own report and direct rejection
control. Ordinary checking and runtime assertions remain required too.

CI runs these checks with read-only permissions. Reports are downloadable from
the workflow run's artifacts when available, including failed-run reports, and
expire after 14 days. Downloads may require GitHub authentication. Unsupported
platforms, missing dependencies and network/setup failures must be reported as
such, never as successful verification. See [VALIDATION.md](VALIDATION.md).

## Editing guidance

Keep this a small teaching skill. Prefer one clear rule, its reason, a pinned
primary source, and a runnable example over a long list of stylistic mandates.
Keep the entry point under 150 lines and load details through focused references.
Keep each example and reference inside the standalone skill directory.

For a language change, inspect the matching `bend guide`, `bend base`, compiler
and tests. Update `toolchain.json`, source links and the validation record together.
Do not change a version string and assume compatibility. Distinguish language
requirements from our style recommendations. Avoid unsupported performance or
whole-program correctness claims.

The current corpus has exactly 100 distinct cases, enforced by the runner. Keep
`tests/cases.json` as its single source of truth; a future deliberate expansion
must update counts, ID ranges, generated indexes and validation records together.
Run `python3 scripts/coverage.py` after changing it. For examples, record an
independent expected-output oracle before running the implementation. Cover relevant
empty, malformed and boundary inputs. For a compiler restriction, add a minimal
negative fixture with a diagnostic specific enough that an unrelated failure
cannot pass. For a law, write the specification before code, preserve its recorded
SHA256, and retain a targeted mutation in `tests/proof-mutations.json`. A mutated
implementation must still type-check by itself and fail the unchanged proof.
State which properties the law leaves unspecified; do not treat a surviving
mutation outside that scope as evidence of a stronger claim. Explain any intended
contract change explicitly and review the law diff before updating its hash.
Keep intentional bad code in `tests/negative/` or evaluation inputs, not as a
copyable positive example. Preserve existing laws while fixing implementations.

Run the commands in [README.md](README.md), and update [VALIDATION.md](VALIDATION.md)
with actual outcomes and skips. For behavior changes to the skill, use a fresh
agent with a realistic task following [evals/README.md](evals/README.md); record
evidence and unresolved problems. Do not claim improved model performance
without controlled comparisons.

Keep `skills/bend-best-practices/LICENSE` identical to the root license and
retain the bundled third-party notice. Cite and respect any newly adapted source.
If packaging changes, validate with the host CLI when available and report when
it is not. Bump the plugin version when preparing a distributable update.
Publishing a branch, PR, release, marketplace listing or BendHub package is a
separate maintainer decision; validation does not perform publication.
