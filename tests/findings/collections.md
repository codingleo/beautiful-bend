# Collection, text and error composition findings

This partition contributes exactly 20 runtime cases, `r21` through `r40`.
`r21` reuses the unchanged `examples/parsing.bend`; the other 19 entry points
and one shared helper are under `examples/suite/collections/`. The manifest is
`tests/cases.json (the collections partition)`. All 20 cases enable normalization.

## Evidence and scope

Validated with `/tmp/beautiful-bend-bin/bend` reporting `bend 2.0.39` and Node
`v24.19.0`. Read the repository skill and core reference; the pinned upstream
`guide/GUIDE.md`, `bend2/base.bend`, and relevant `tests/base/` examples supplied
the authoritative syntax, quantities, parser behavior, map ownership, and list
operation signatures. `bend version`, `bend --help`, and `bend guide` were read.

Expected stdout and each independent behavioral oracle were written to the
manifest **before the first compiler execution of these cases**. Arithmetic
expectations were computed by hand (sum of squares, zipped costs, quotient,
counts); collection/text expectations follow explicitly stated ordering,
truncation, ASCII grammar and code-point rules. First-pass failures changed
callback adapters only. No expected stdout was changed to match compiler output.
The r40 oracle wording was corrected to describe its actual `[b,A,a]` sample;
its expected stdout and source remained unchanged.

The first execution attempted 72 commands: 20 entry checker calls, 17
normalizations, 17 JS emissions, 17 Node runs, and 1 helper checker call.
**69 passed; 3 checker calls failed.** No runtime mismatch occurred. After the
three source fixes, the final execution ran **81 commands, all passing**:

- 21 `bend FILE --check-only` calls: exit 0 and `ALL PROOFS CHECK`, with no
  conflicting failure verdict.
- 20 `bend FILE` normalizations: exit 0 and exact manifest stdout.
- 20 `bend FILE -o /tmp/collections-artifacts/rNN.js` emissions: exit 0.
- 20 `node /tmp/collections-artifacts/rNN.js` executions: exit 0 and exact
  manifest stdout, including the trailing newline.

Across both executions there were 153 commands, 150 passing and 3 failing.
The final manifest/accounting check also confirmed contiguous unique r21..r40
IDs and coverage of all 20 new `.bend` files (19 entry points plus the helper).
Local command-level evidence remains in
`/tmp/collections-artifacts/first-pass.json` and
`/tmp/collections-artifacts/report.json`; these temporary paths are not required
to run the repository fixtures. The temporary runner was
`/tmp/check_collections.py`.

## First-draft failures and fixes

All three failures were code errors exposing the same missing practical detail
in the skill's higher-order function guidance: binder quantities are part of
function types. A reusable top-level definition can be called repeatedly, but
its `@+x:A -> B` type does not match the ordinary affine `@_:A -> B` callback
expected by many Base operations.

| Case | First diagnostic | Fix |
|---|---|---|
| r22 energy_total | expected `@_:U32 -> U32`, observed `@+x:U32 -> U32` at the `List.map` template | `~(x => square(x))` adapts the affine callback to the reusable callee |
| r35 optional_timeout | expected `@_:U32 -> Maybe<&2, U32>`, observed `@+value:U32 -> Maybe<&2, U32>` at `Maybe.bind` | `x => seconds(x)` |
| r38 word_counts | expected affine second argument, observed `@+key:String` at `List.foldl` | `~(counts => key => increment(counts, key))` |

No `@unsafe`, proof holes, changed laws, or unchecked recursion were introduced.
There were no other first-draft checker failures or observed output mismatches.

## Guidance worth adding

1. Explicitly distinguish repeated calls to a named def from compatibility of
   that def's parameter quantities with a higher-order callback type. Show an
   affine lambda adapter around a reusable-parameter function.
2. List quantities vary across Base APIs: `List.map` takes and returns `&1`
   lists; `List.filter`, `List.find` and `List.sort` use `&2`; folds take an
   explicit template quantity. Inspect actual signatures before composing them.
3. `List.zip` intentionally truncates to the shorter input. Record whether this
   is the application's contract or validate lengths separately. `List.drop`
   and `List.take` safely clip at list boundaries.
4. `String.split` uses one `Char`, preserves consecutive/trailing empty fields,
   and returns one empty field for empty text. It is not a CSV quote parser.
   String length/slicing operate on code points, not UTF-8 bytes or grapheme
   clusters. Base trim and case conversion cover ASCII whitespace/case; avoid
   promising Unicode normalization.
5. For strict domain tokens, state the grammar explicitly and check it before
   bounded number conversion. `decimal.bend` requires nonempty ASCII digits,
   excludes signs/whitespace/Unicode digits, and lets `U32.read` reject overflow.
6. `Map.get(V, default, map, key)` returns the owner beside the value. Match that
   computed pair in a helper. `Map.union(left,right)` lets right-hand values win.
   Sort keys/tags before promising deterministic presentation order.
7. `Result` carries separate error/value quantities and error/value types.
   Distinguish sequential first-error propagation (r33/r34/r36), per-record
   recovery with an explicit rejection count (r37), and Maybe fallback that
   preserves a legitimate zero (r35).

## Limits

These finite pure examples establish agreement between checker normalization
and emitted JavaScript on the recorded samples. They do not prove general
application correctness. No Lean/BendTT `--verdict`, native CPU compilation,
GPU execution, performance measurements, arbitrary IO, filesystem/network
behavior, or installation was attempted. Arithmetic examples state bounded
inputs where unchecked U32 sums/products are used; these are not production
unbounded financial calculations. No blocker remains for this partition.
