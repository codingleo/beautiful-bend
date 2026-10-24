# Effects and arrays

Scope: Bend 2.0.39. See [sources](sources.md) for the guide, Base, CLI and tests.

## Keep errors as values until the boundary

Use `Maybe` when absence or a parse failure is enough; use `Result` when a
caller needs an error reason. Bend's constructors are `Some`/`None` and
`Done`/`Fail`. Quantity and type parameters differ from Rust and Haskell.

[parsing.bend](../examples/parsing.bend) combines two `U32.read` results in a
`do Maybe<&2, U32>:` block. A `None` propagates; a valid zero remains `Some{0}`.
It tests success, bad text, and zero. It does not validate a business range or
detect sum overflow. Add those policies when the domain requires them.

In `do` blocks, annotate each bind: `x : A <- action`. A pure binding uses
`x : A = value`; `return value` wraps a pure result in the monad. For `IO(Unit)`,
an `IO.print` action can be the final expression. See
[effects.bend](../examples/effects.bend) for a complete, deterministic IO shell.

`IO.try(A, action)` unwraps a fallible IO result **or exits**. It is appropriate
when failure should terminate the application; it is not a recovery strategy.
For recoverable errors, retain the result and pass it to a helper that matches
`Done`/`Fail`. Inspect the actual `IO`, `File`, `TCP`, or `Process` operation
with `bend base NAME`, including the returned owner and error payload.

## Follow ownership through each operation

Arrays and handles are affine. Operations on handles return the owner alongside
their result; continue with that owner. Do not retain a stale handle or add `+`
to fake shared ownership. Close resources with the Base operation appropriate to
the resource, including on recoverable failure paths. Dropping an affine value
is allowed by the language; that is not a substitute for understanding external
resource lifecycle behavior.

Array notation has sharp edges in this pin:

- `[0 : U32*8n]` creates eight slots; the capacity is a power of two.
- `cells[i] <- value` followed by another statement rebinds `cells`; as the
  final expression it returns the written array.
- A read returns the array **and** the value. Pass that computed pair to a
  helper to match it. The compiler rejects a direct destructuring let on that
  computed read; the verified example shows the required form.
- Indices wrap. If an API requires out-of-range rejection, validate the index
  before accessing it; do not describe wrapping as bounds rejection.
- The indexing sugar assumes `Array<U32>`. For other elements, inspect
  `Array.get` (requires `Data` elements), `Array.swap`, and `Array.set`.
  `Array.clone` is an explicit copy, not a remedy to apply to every ownership
  diagnostic.

[arrays.bend](../examples/arrays.bend) writes slot zero, reads it, then reads
index eight using the returned owner. Both reads yield 17. It deliberately
documents wrapping, so users do not mistake it for a safe indexing wrapper.

## Distinguish concurrent effects from parallel computation

`IO.fork` returns a channel for another computation; `IO.join` waits for it.
This is effect scheduling on the event loop, distinct from pure fork/join
calls. `IO.within` timing out does not cancel the losing action. Account for
its eventual effects and resources; do not treat a timeout as rollback.

Custom effects need backend-specific host implementations. Read the installed
`bend guide effects` and implementation; that upstream extra is labelled an
AI-written note awaiting human revision. This initial skill does not validate
custom effects, networking, GUI/audio, cancellation, or resource recovery.
