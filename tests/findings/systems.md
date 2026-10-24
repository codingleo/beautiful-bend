# Systems partition: r41–r60

Exactly 20 runtime cases: three existing entrypoints (`arrays.bend`,
`effects.bend`, `parallel_tree.bend`) and 17 new applications under
`examples/suite/systems/`. `workloads.bend` is the sole new support module and
is not a case. The manifest is `tests/cases.json (the systems partition)`.

## Toolchain and gates

Verified with `/tmp/beautiful-bend-bin/bend`, reporting **Bend 2.0.39**, and
**Node v24.19.0**. Read the repository skill, core/effects/parallel references,
`bend --help`, `bend guide`, `bend base Array`, and `bend base IO`; checked
needed details against `/tmp/beautiful-bend-upstream/bend2/base.bend` and
upstream array/fork-join fixtures. The temporary upstream tree was read only.

For every entrypoint, the validation script ran these commands independently
with captured stdout/stderr and a 20-second timeout per stage:

```text
/tmp/beautiful-bend-bin/bend <entrypoint> --check-only
/tmp/beautiful-bend-bin/bend <entrypoint>                    # pure mains only
/tmp/beautiful-bend-bin/bend <entrypoint> -o /tmp/bend-systems-rNN.js
node /tmp/bend-systems-rNN.js
```

Every stage required exit code **0** and **empty stderr**. Check-only stdout had
to equal `ALL PROOFS CHECK\nUse --verdict for mathematical validity.\n` exactly.
Emission stdout had to be empty. Normalization and Node stdout had to equal the
manifest `stdout` byte for byte. IO entrypoints were never normalized.

Final results: **20/20 check-only**, **15/15 pure normalization**,
**20/20 JavaScript emission**, **20/20 Node runs**, and **1/1 separate support
module check**: **76 successful exact stage assertions**. The final clone
strengthening was rerun through all four affected stages; all other final
sources already passed unchanged. Temporary detailed stage records are in
`/tmp/bend-systems-results.json`; initial failures are retained in
`/tmp/bend-systems-initial-results.json` during this workspace session.

## Oracles and meaningful boundaries

The manifest records expected-result reasoning established from the intended
operations before executing the programs. Assertions include complete values,
not just agreement booleans or successful exit. Right-associated tuple rendering
and one existing source literal needed the corrections documented below.

- r41–r50: returned array ownership, wrapping, depth-zero capacity one,
  capacity versus depth notation, String get/set, returned old swap value,
  clone independence in both directions with all slots inspected, U32-to-Bool
  mapping at a strict threshold, multi-step inventory updates, and a checked
  index wrapper that accepts capacity minus one and rejects capacity itself.
- r51–r54: balanced positional checksum (`1120`), skewed sum/count (`15`, `3`),
  empty neutral results, and independent square tasks (`85`) versus a dependent
  square-of-sum pipeline (`169`). Tree outputs also agree with sequential
  definitions; the arithmetic oracle supplies an independent check.
- r55–r58: exact write/print order and newline behavior; explicit nested
  `IO.pure`/`IO.bind`; independent `IO.fork` results joined in reverse creation
  order; and a dependent fork that consumes the prior joined result. Forked
  computations have no printing or nondeterministic inputs; only the parent
  prints, after joining, and compares with direct sequential calculations.
- r59–r60: zero-work/zero-fuel completion, exhausted fuel with remaining work,
  exact-fuel completion, empty command identity, exact stock depletion,
  rejected underflow, and later valid state transitions.

## Initial failures and diagnosis

No runtime semantic discrepancy was found. Initial fixture and serialization
failures were retained rather than suppressed:

| Cases | Initial failure | Diagnosis and final correction |
| --- | --- | --- |
| r42 | Expected `invalid`, observed `invalid number` | The existing `Parse.describe` source explicitly returns `invalid number`. Corrected transcription of that source literal; preserved the full exact output assertion. |
| r44, r59 | Right-nested tuple expected with extra parentheses | Bend prints right-associated pairs as flat tuple syntax. Corrected serialized stdout; values and tuple types unchanged. The same established rendering rule was applied to r52/r53 before their successful normalization. |
| r47 | `expected: 2 patterns (one per scrutinee)` for two adjacent tuple patterns | Computed results still need parameter helpers. Parameter tuple destructuring passed; final stronger fixture instead matches the clone pair once, updates both owners, and converts each whole array to a list. |
| r51–r53 | `expected: an annotated term (cannot infer)` at reusable constructor binding | Constructor-only local binding needed `+tree : Work.Tree = ...`. Added its type, with no change to the workload. |
| r60 | `expected: a defined name`, `U32.is_lte` | Base defines `U32.is_le`, not `is_lte`. Used the actual signature; exact-depletion and rejected-underflow expectations unchanged. |

A discovery attempt at `/tmp/beautiful-bend-upstream/bend2/tests` failed because
upstream tests live in `/tmp/beautiful-bend-upstream/tests`; the corrected path
was used. `bend base U32.is` also reported no such aggregate name; inspected the
actual `U32.is_*` definitions in Base instead. Neither was a runtime failure.

## Guidance gaps and limits

The skill correctly calls out array ownership, wrapping, non-U32 API use,
templates, and JavaScript's sequential lowering of pure parallel calls. These
cases add evidence for capacity/depth and depth zero, mapping to another element
type, clone independence, explicit index validation, and deterministic IO
composition. Useful clarifications for future guidance are that inferred local
constructor bindings may need an explicit type and that printed right-associated
tuples flatten their outer syntax. Query exact Base names rather than guessing
comparison suffixes or treating a prefix as a Base namespace.

All runtime evidence is JavaScript/Node only. It establishes returned values and
specified parent-side effect order, **not** CPU scheduling, speedups, GPU
execution, native memory safety, cancellation, or timing behavior. IO fork/join
completion on JS is observed; no concurrency order between forked tasks is
asserted. No network, process-execution effects, filesystem effects, GUI,
randomness, sleeps, native backend, or GPU backend were tested. No kernel verdict
was requested; checker acceptance is distinct from kernel verification. No laws
were changed, unsafe definitions added, dependencies installed, network requests
made, or commits/pushes performed. No remaining blocker.
