# Core idioms

- [Domain](#model-the-domain-then-consume-it) · [Quantities](#make-quantities-visible)
- [Matching](#let-the-match-expose-progress) · [Arithmetic](#spell-arithmetic-and-failure-precisely) · [Anti-patterns](#common-wrong-turns)

Scope: Bend 2.0.39. Language facts below come from the pinned [guide and
implementation](sources.md). Naming and decomposition advice are project
recommendations. Complete [examples](examples.md) are compiler-tested; fragments
in this reference illustrate only the stated form.

## Model the domain, then consume it

Declare alternatives as constructors with the fields they need. A `Charge` with
units and cents and a `Complimentary` line communicates more than a flag plus
conditionally meaningful fields. Match exhaustively where the domain is closed.
Prefer small functions such as `line_cents` and `total_cents` over one function
that parses, calculates, and prints. See [invoice.bend](../examples/invoice.bend).

`is Data` permits reusable values; `is Type` keeps them affine. Choose `Data`
because the fields support copying and the domain benefits from it, not to silence
an ownership error. A list of closures is not a list of copyable functions.

## Make quantities visible

| Binder | Meaning | Habit |
|---|---|---|
| `x: A` | Use at most once; dropping is allowed | Start here |
| `+x: A` | Reuse; `A` must have kind `Data` | Mark the smallest needed binder |
| `-x: A` | Erased; only types/proofs may use it | Do not use it in runtime work |
| `~f: A -> B` | Template substitution at compile time | Supply closed syntax |

For a square, `def square(+value: U32) -> U32:` permits
`(value * value : U32)`. This does not justify making every argument reusable.
Matching a reusable value makes its fields reusable; a plain pattern can mark
one field `+name`. `List<U32>` defaults to `List<&1, U32>`; write `+List<U32>` or
`List<&2, U32>` when the **list itself** must be reusable. A `+` binder alone
does not repair an affine list type.

A runtime closure, including a partial application, can be called once even if
its captures are `Data`. Repeated calls to a named top-level definition are fine.
Use a template when the operation is known at compile time. Template parameters
come first; their arguments cannot capture a local variable. Look up the actual
signature: `List.map(~U32, ~U32, ~increment, values)` is verified in
[quantities.bend](../examples/quantities.bend). For a runtime captured value, pass
it as an explicit recursive argument, reusable only if its type permits it.

## Let the match expose progress

Recursion is structural: recursive arguments are read left to right. Earlier
arguments must be unchanged until one is a smaller pattern-derived piece;
later arguments may change. Thus use `total_cents(lines, acc)` and recurse on
`rest` before updating `acc`. Reordering this to `sum(acc, values)` can fail.
Do not replace a termination error with `@unsafe` or `def f?`.

Match only parameters or fields obtained by matching, in binder order. No
computed scrutinees, no preceding `let` before a parameter match. Move computed
decisions into a small helper that receives the decision as a parameter.
`describe(parsed_sum(...))` in [parsing.bend](../examples/parsing.bend) shows this.
The same limitation applies to destructuring a computed pair with `=`; see
[arrays.bend](../examples/arrays.bend). A function that handles two domains can
often use `match a b:` with one case table instead of tangled nested logic.
Skipping an earlier parameter is allowed if it is not subsequently matched;
matching it after a later parameter is the rejected ordering.

Use `match` on `True{}`/`False{}`; this version has no `if` syntax. Ordinary
functions return their last expression. `return` belongs to `do` notation.
Safe defs may call earlier defs or themselves with structural progress; do not
assume general forward calls or mutual recursion. Keep helper definitions above
their callers. Datatypes have different ordering rules; consult the guide for
recursive types instead of forcing a code-order workaround.

## Spell arithmetic and failure precisely

| Intent | Bend form |
|---|---|
| Bounded machine integer | `U32`, literal `42` |
| Structural natural number | `Nat`, literal `42n` |
| Typed arithmetic | `(x + y : U32)` or `U32.add(x, y)` |
| Runtime comparison | `U32.is_eq(x, y)` or `(x < y : U32)` |
| Equality proposition | `{x == y : U32}` |
| Optional result | `Maybe` with `Some` / `None` |
| Result with an error | `Result` with `Done` / `Fail` |

Keep spaces around operators. Do not assume that a return type supplies the
operator annotation. Choose and document overflow behavior: `U32` arithmetic
wraps, so an invoice demo with bounded inputs is not production money arithmetic.
Use `Nat` or an explicit checked design when unbounded counts or overflow
rejection are part of the contract. Inspect parsing and conversion behavior in
Base; do not promise that one parser accepts another language's number grammar.

## Common wrong turns

| Anti-pattern | Why it fails or misleads | Repair |
|---|---|---|
| `f(f(x))` for runtime parameter `f` | Consumes the closure twice | Closed template, top-level def, or explicit state |
| `+array` | `Array` is `Type`, not `Data` | Thread its returned owner through calls |
| `match parse(text):` | Computed scrutinee | Helper receiving the parsed value |
| `(a, x) = a[i]` on a computed read | Desugars to a disallowed match in this pin | Helper matching the returned pair |
| `value + 1` | Missing operator type | `(value + 1 : U32)` |
| Change the accumulator before a later shrinking argument | Fails structural progress | Put the shrinking parameter first |
| Return `0` on parse failure | Hides the difference from a valid zero | Keep `None` or a domain error |
| Rust `Result<T,E>`, `?`, borrowing or `.iter()` by analogy | Different names, parameters and semantics | Inspect `bend base` |

The repository's `tests/negative/` pins compiler refusals separately from style
advice. Read [sources](sources.md) when a newer compiler disagrees.
See [composition](composition.md) for callback adapters, imported-name collisions,
and numeric/text boundaries found while exercising the complete examples.
