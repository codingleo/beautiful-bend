# Validation record — 100 cases, 2026-10-24

**Passed: 100/100 cases, 320/320 command expectations, and 15 validator integrity
unit tests.** The suite includes the original 17 cases plus 83 new cases.
See [the complete coverage matrix](COVERAGE.md), [observed run summary](validation/2026-10-24-100.json),
and [initial-version record](validation/2026-10-24-initial.md).

Environment: Linux x86_64 cloud workspace, Python 3.12.14, Node v24.19.0,
Bun 1.4.4. Bend **2.0.39**, source revision
`295e996574573e3a88827b1cf7045b437333c8f0`; no upstream compiler changes.
The official `bendlang/bend` main resolved to the same revision on 2026-10-24.
The source pin stayed fixed throughout the suite.

## What the 100 cases establish

| Kind | Cases | Assertions / scope |
|---|---:|---|
| Law/proof projects | 15 | 19 law declarations; ordinary check-only and no-main proof gate both accept |
| Runtime programs | 60 | Every entry checks, emits JS and produces exact expected Node stdout; 53 also normalize to the same stdout |
| Expected rejection | 25 | Exit 1, `SOME PROOFS FAIL`, and the intended diagnostic; no unsafe/foreign fixture execution |

The proof projects have separate LAWS, implementation and PROOF files. Fourteen
new specifications were written before their implementations; final law hashes
were recorded after the first development sweep, not before it. The original
counter laws stayed byte-identical. One new workflow constructor was mechanically
renamed from `Done` to `Finished` after an imported-name collision; all predicates
and quantifiers were retained. [The law diff and hashes](tests/findings/proofs-rejections.md)
record that correction. No law was weakened to achieve acceptance.

Each proof project also has a targeted mutation with unchanged LAWS. Thirteen
mutated implementations still pass standalone checking but their proofs fail;
two further checks reject an incorrect equality proof or existential witness.
Counterexamples and exact scope limits appear in [mutation findings](tests/findings/proof-mutations.md).
These checks are outside the 100-case count, as are two additional counter/import
integrity checks, helper files, unit tests and model evaluations.

**The laws establish their stated properties, not whole implementations.** For
example, map length does not establish payload increments; involution alone does
not uniquely specify a toggle or mirror; equality transport does not certify a
business policy. Sample-tested values/order and universally quantified claims
are identified separately. None of these results is independent BendTT verification.

## Exact final command accounting

| Commands | Count | Expected outcome |
|---|---:|---|
| Bend and Node version reads | 2 | Success; Bend exactly 2.0.39 |
| Positive entry `--check-only` | 75 | Exit 0 and `ALL PROOFS CHECK` |
| Plain `PROOF.bend` gates | 15 | Exit 0 and `ALL PROOFS CHECK` |
| Pure normalization | 53 | Exact stdout |
| JS emission | 60 | Exit 0 |
| Node execution | 60 | Exact stdout including final newline |
| Negative fixtures | 25 | Intended rejection |
| Valid mutated implementation checks | 13 | Accepted before checking false law |
| Fixed-law mutation proof checks | 15 | Intended rejection |
| Additional counter/import integrity checks | 2 | Intended rejection |
| **Total** | **320** | **All expectations met** |

Five IO programs and two F32 programs do not request concrete normalization.
The F32 attempts during development returned residual terms, while compiled JS
met the prewritten numeric expectations. They are reported as compiled-only
runtime checks, not silently counted as successful normalization. The runtime
suite uses small, finite inputs; no broad numerical-conformance or speed claim.

The full report contains exact commands, exits, stdout and stderr and is generated
at `.validation/100-final.json` (ignored to avoid dirtying subsequent runs).
The committed compact summary records all 320 outcomes and each case source hash.
The runner fails on missing tools, wrong Bend version, timeout, wrong output,
unrelated compiler failure, missing case, changed law digest or stale mutation.
It continues independent cases after command failures and labels subset runs.

## Findings and improvements

The initial assembled 100-case run passed 292 commands, including the original
two integrity mutations. After strengthening every proof project, the final
full run passed 320. Earlier authoring failures were retained in the findings:

| Evidence | Initial finding | Implemented improvement |
|---|---|---|
| [Core](tests/findings/core.md) | Imported `Event`/`Ready` collide; leading negative float rejected; F32 normalization residuals | Domain naming guidance, `F32.neg`, separate compiled/normalized evidence |
| [Collections](tests/findings/collections.md) | Three callback quantity mismatches: initial 69/72 commands passed; final 81/81 | Affine lambda adapters; quantity-aware composition and explicit parser/error policies |
| [Systems](tests/findings/systems.md) | Missing constructor annotation, guessed Base name, tuple serialization and literal transcription errors | Explicit local types, exact API lookup, stronger all-slot clone assertions; final 76 stage assertions passed |
| [Proofs/rejections](tests/findings/proofs-rejections.md) | First proof sweep 12/15 accepted; one negative unexpectedly accepted; two negatives initially hit the wrong guard | Fixed list-head syntax and rewrite motive; clarified match ordering; targeted diagnostics; final 55 checks passed |
| [Mutations](tests/findings/proof-mutations.md) | Partial laws leave some behaviors unspecified | 15 targeted mutations, 13 standalone-valid mutants, explicit contract limits; 58 discovery/replay checks passed |

Core's final partition run passed 78 stages; its first scratch harness had also
misread an explanatory checker-banner line. The record distinguishes that harness
error from language rejections. Development counts above are separate local runs,
not additional cases or a combined universal pass rate. Expected numerical values
were not replaced with observed outputs; documented adjustments were serialization,
source-literal transcription and a renamed constructor. No performance claims
were inferred from these runs.

The improved skill puts law design before implementation, adds focused
[composition guidance](skills/bend-best-practices/references/composition.md),
and keeps all positive examples/references inside the installable directory.
The small entry point routes to details instead of embedding 100 examples.
The entire skill was also copied to a fresh directory: all local links and
relative Bend imports resolved inside the copy, two relocated proof gates passed,
and a collection example emitted/executed with its exact output (four commands).
The [skill update inventory](validation/skill-update-files.txt) lists seven changed
existing files and 98 new files, including 97 Bend example/support files. Account-wide
installation updates should copy the complete skill directory after review.

## Agent guidance evaluation

One new **fresh Astra** run completed a novel duplicate-readings repair/proof task
with the updated skill and no rubric or suite answers. Independent review ran
six commands: proof gates, main check, JS emission/execution, and a rejecting
regression; it checked original LAWS byte-for-byte. All four rubric items passed.
See [prompt, artifacts, counts and limits](evals/results/2026-10-24-100.md).
The original parse-quantities evaluation remains separately recorded.

Authoring agents had access to expectations, so their runs are compiler-fixture
development, not blind guidance evaluations. No repeated with/without-skill
comparison has been run; these two observed uses do not establish broad agent
improvement. Four original evaluation tasks remain unrun.

## Reproduce

Use the [pinned toolchain](toolchain.json). The source/Bun setup is documented in
[the initial record](validation/2026-10-24-initial.md#reproduce-the-checks). Source
and tools remain outside this repository; the official installer was not executed.
From the Beautiful Bend root:

```sh
python3 scripts/coverage.py --check
python3 scripts/validate.py --structure-only
python3 -m unittest discover -s tests -v
python3 scripts/validate.py --bend /absolute/path/to/bend --report .validation/results.json
```

`--case p06` is a development subset and is explicitly labeled as such. Full mode
always checks all 100 cases and mutations. Every child command has a 60-second
timeout. The CI workflow installs the pinned Bun version, checks out the exact
upstream source revision, and runs these same structure/unit/full-suite gates.
It does not invoke the website installer or publish a package.

## Unavailable or untested layers

| Layer | Exact status |
|---|---|
| Official installer | Earlier `curl -fsSL https://bend-lang.com/install.sh -o /tmp/beautiful-bend-install.sh` returned HTTP 403; not retried or executed |
| Independent BendTT kernel | Earlier `bend PROOF.bend --verdict` failed before verification: `EROFS: read-only file system, mkdir '/home/agent/.bend'`; Lean/elan absent. No retry or filesystem workaround |
| Native CPU | Not run; documented clang toolchain absent |
| GPU / performance | No GPU execution, scheduling, speedup or scaling evidence |
| External effects | No network/filesystem/process effects, custom foreign runtime, GUI/audio, cancellation or recovery-path tests |
| Host loading | Claude CLI unavailable; Codex automatic discovery not exercised. Explicit standalone skill use passed |
| Other platforms | No macOS, CUDA or Metal tests |

Remote CI for the initial commit succeeded. The expanded workflow must be
inspected for the exact published commit; its result will be reported in the
handback with the direct Actions link, not inferred from local success.
