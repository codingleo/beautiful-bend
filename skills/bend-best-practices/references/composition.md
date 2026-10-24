# Composing small, lawful programs

Scope: Bend 2.0.39 at the [pinned sources](sources.md). These details were checked
against Base signatures and the bundled examples. Decomposition and presentation
advice are project preferences, not additional language rules.

## Match the callback's quantities

Repeated calls to a named definition are legal. Passing that definition as a
callback is a separate type question: quantities belong to its function type.
A `def square(+x: U32)` does not directly fit the affine `U32 -> U32` callback
expected by `List.map`. The verified adapter is:

```bend
List.map(~U32, ~U32, ~(x => square(x)), readings)
```

The lambda's parameter is consumed once by `square`, which can reuse it internally.
See [energy total](../examples/suite/collections/energy_total.bend). Similarly,
[optional timeout](../examples/suite/collections/optional_timeout.bend) adapts
`seconds` for `Maybe.bind`; [word counts](../examples/suite/collections/word_counts.bend)
adapts the reducer for `List.foldl`. Inspect the actual signature rather than
adding `+` everywhere. Template arguments still must be closed.

`List.map` takes and returns `&1` lists; `filter`, `find` and `sort` use `&2`.
Folds take an explicit template quantity. Check these when composing pipelines;
a reusable binder cannot change a list's declared quantity.

## Make names and intermediate types clear

Base already declares names such as `Event`, `Ready` and `Done`. Constructor
names are globally unique across imports, even through a module alias. Choose
meaningful domain names, such as `GateEvent` or `Finished`, rather than hiding
an import that the contract requires. See
[the workflow model](../examples/suite/proofs/workflow_reset/model.bend).

For an intermediate reusable constructed value, supply its type where inference
needs it: `+tree : Work.Tree = ...`. Keep helpers above their callers. Parenthesize
Nat successor expressions used as list heads: `(1n+h) <> rest`.

## Specify numeric boundaries before choosing operations

[Checked addition](../examples/suite/core/checked_add.bend) tests
`right <= 4294967295 - left` before adding. [Checked multiplication](../examples/suite/core/checked_multiply.bend)
handles zero, then tests `right <= floor(4294967295 / left)`. These fixtures assert
both exact-limit successes and overflow failures. Other bounded U32 examples
state their input assumptions; they are not arbitrary-precision money libraries.

Use `F32.neg(0.5)` for a negative half in this pin; a leading `-0.5` is rejected.
[Quarter units](../examples/suite/core/quarter_units.bend) and
[sensor calibration](../examples/suite/core/sensor_clamp.bend) use exact
binary fractions. Their compiled JS results are tested; F32 primitive expressions
remain residual terms under checker normalization. This is not a test of NaNs,
infinities, subnormals, general decimal rounding, or native floating-point behavior.

## Preserve library semantics at application boundaries

- `List.zip` truncates to the shorter input. Validate lengths separately when
  unequal lengths are an error. `take` and `drop` clip at list boundaries.
- `String.split` takes one `Char` and preserves consecutive/trailing empty
  fields; empty input yields one empty field. It is not a quoted CSV parser.
- String length and slicing use code points, not bytes or grapheme clusters.
  Base trim/case conversion here cover ASCII rules, not Unicode normalization.
- [Decimal tokens](../examples/suite/collections/decimal.bend) explicitly require
  nonempty ASCII digits before calling `U32.read`, which rejects overflow.
  Signs, whitespace and Unicode digits are outside this contract.
- `Map.get` returns the owner beside the found/default value; match that pair
  in a helper. `Map.union(left, right)` gives right-hand values precedence.
  Sort keys when the presentation contract requires a particular order.
- Distinguish first-error `Result` propagation, per-record recovery with a rejected
  count, and `Maybe` fallback that preserves a legitimate zero. Each is a policy.

These are finite tested compositions. Turn required invariants into laws and
prove them when the project needs universal claims; sample outputs alone do not
establish them.
