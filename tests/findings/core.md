# Core runtime partition findings

## Deliverables and final validation

`tests/cases.json (the core partition)` contains exactly 20 runtime cases, `r01` through
`r20`, with an empty support list. The first three reference the unchanged
`invoice.bend`, `quantities.bend`, and `laws/main.bend` examples. The remaining
17 entry points live under `skills/bend-best-practices/examples/suite/core/`.
No new helper imports were needed. Existing laws support files remain owned by
the main suite's support/proof inventory.

Final checks: **78 passed, zero failed**:

- 20 `--check-only` calls with successful exit and exact checker output.
- 18 normalization calls with successful exit and exact concrete stdout.
- 20 JavaScript emissions with successful exit.
- 20 Node executions with successful exit and exact concrete stdout.

The two omitted final normalization calls are `r16` and `r17`; both still
require checker acceptance and successful JavaScript execution. Their earlier
normalization attempts are recorded below, not counted as passing concrete
normalizations. No native CPU build, GPU run, performance claim, or BendTT
kernel check is part of this partition.

Toolchain: `/tmp/beautiful-bend-bin/bend` reports `bend 2.0.39`; Node reports
`v24.19.0`. The local upstream checkout `/tmp/beautiful-bend-upstream` is revision
`295e996574573e3a88827b1cf7045b437333c8f0`. Inspected `bend version`, `bend --help`,
`bend guide`, `bend base F32`, and the pinned Base/compiler sources.

Each stage used Python `subprocess.run` with a direct argument list, captured
stdout/stderr, a 60-second timeout, and `BEND_NO_TELEMETRY=1`. Commands were:

```text
/tmp/beautiful-bend-bin/bend <case.file> --check-only
/tmp/beautiful-bend-bin/bend <case.file>
/tmp/beautiful-bend-bin/bend <case.file> -o /tmp/core-validation/<id>.js
node /tmp/core-validation/<id>.js
```

The normalizing command runs only when the manifest says `normalize: true`.
The checker stdout is exactly:

```text
ALL PROOFS CHECK
Use --verdict for mathematical validity.
```

The scratch runner and complete per-command reports are `/tmp/check-core.py`
and `/tmp/core-validation/report.json`. First-pass evidence is preserved in
`first-check-report.json` and `first-runtime-report.json` in that directory.
These temporary files are supporting evidence, not required suite deliverables.

All numeric/domain outputs and their mathematical explanations were written
before running the programs. No numeric expectation changed in response to
compiler output. For example, checked addition tests the exact condition
`right <= 4294967295 - left`; checked multiplication first handles zero and then
tests `right <= floor(4294967295 / left)`. The multiplication boundary
`65535 * 65537 = 4294967295` fits, whereas `65536 * 65536` does not.

## First-draft failures and guidance gaps

1. **Imported names can collide with domain names.** The first `r05` draft used
   `type Event`, rejected with `a fresh name (duplicate declaration: Event)`.
   The first `r12` draft used constructor `Ready`, rejected with
   `a fresh constructor name (duplicate declaration: Ready)`. The successful
   repairs use `GateEvent` and `Versioned`. The latter's expected constructor
   spelling changed accordingly; its values and duplication contract did not.
   The current core guide encourages domain constructors but does not warn that
   names imported from Base occupy these namespaces. Supporting pinned sources:
   `bend2/base.bend:44` declares `Ready`, and `bend2/base.bend:89` declares
   `Event`; `bend2/bend.ts:2422` implements `parse_fresh`, and
   `bend2/bend.ts:2529` applies it to constructors. These paths are relative to
   the upstream revision recorded above.

2. **Negative floats need explicit negation.** The first `r17` draft used
   `percent(-0.5)`, rejected with `expected : a term`, `observed : '-'`.
   The successful repair is `percent(F32.neg(0.5))`; the intended negative
   boundary and expected zero result are unchanged. The pinned parser's
   `bend2/bend.ts:1751` (`parse_term_base`) dispatches numeric literals only
   when the first character is a digit (`:1797`); `parse_term_num` is at `:2197`.
   `bend2/base.bend:1716` declares `F32.neg`; `bend2/comp.ts:175` implements it
   for compiled backends. The skill's numeric table currently gives positive
   literals and does not explain this negative-value syntax.

3. **F32 normalization is not concrete F32 execution in this pin.** Both `r16`
   and `r17` initially requested normalization. They exited successfully but
   produced residual terms, while the emitted JS passed the original numeric
   stdout assertions. A representative `r16` component was:

   ```text
   F32.to_u32(F32.mul(F32.mul(U32.to_f32(3), 0.25), 100.0))
   ```

   A representative `r17` component was:

   ```text
   F32.to_u32(F32.mul(lower_bound(F32.is_lt(0.25, 0.0), 0.25), 100.0))
   ```

   The exact JS outputs remain `(0, 25, 75, 200, 0n, 17n)` and
   `(0, 0, 25, 100, 100)`, each followed by a newline. Final metadata explicitly
   uses `normalize: false` for these two cases. Supporting pinned sources:
   `bend2/base.bend:1673`, `:1677`, `:1691`, and `:1802` declare `U32.to_f32`,
   `F32.to_u32`, `F32.mul`, and `F32.is_lt` as laws; `bend2/comp.ts:170` maps
   integer-to-float conversion to `Math.fround`, `:173` supplies F32 arithmetic
   intrinsics, and `:194` supplies the JS float-to-U32 implementation. The
   observed residual terms establish the normalization limitation; the compiler
   intrinsics explain why the compiled path can evaluate the same expressions.
   Guidance should distinguish normalization from compiled primitive execution,
   and should not imply that every small pure numeric program normalizes to a
   concrete value. The exact binary fractions here avoid rounding-dependent
   decimal expectations; this is not broad floating-point conformance coverage.

4. **Test-harness correction, not a Bend program failure.** The initial scratch
   runner expected only `ALL PROOFS CHECK\n`, so 17 valid check-only calls were
   initially flagged for the additional `Use --verdict...` line. It was updated
   to assert the complete pinned banner. That first batch had three genuine
   program rejections described above. The next batch had 78 successful stages
   and the two residual-normalization mismatches; the final batch has all 78
   required stages passing. The shared suite may instead require the exact
   verdict line while tolerating the additional explanatory line.

## Scope limits

These are finite behavioral checks, not general correctness proofs. U32 domain
arithmetic outside the explicitly checked-add/multiply examples assumes bounded
inputs. Nat samples remain small, so this partition makes no claim about huge
Nat normalization, backend representation limits, or large Nat conversions.
`r03` runs the real counter implementation; it does not replace the separate
laws/PROOF checker or kernel gate. The grid example demonstrates accepted
lexicographic descent, including resetting the later column argument when the
earlier row argument shrinks. No invalid positive fixture, `@unsafe`, proof
hole, external installation, network access, commit, or publication was needed.
