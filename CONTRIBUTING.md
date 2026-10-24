# Contributing

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
