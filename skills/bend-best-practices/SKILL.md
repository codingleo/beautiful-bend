---
name: bend-best-practices
description: >-
  Write, review, refactor, debug, and explain idiomatic Bend from bend-lang.com
  (Bend 2, bendlang/bend). Use for .bend files, affine quantities, structural
  recursion, Base APIs, laws and proofs, IO, arrays, or parallel calls. Establish
  the compiler and language generation before applying these rules; this is not
  a guide to the older HigherOrderCO/HVM-based Bend.
---

# Beautiful Bend

Write small, typed functions whose data flow and obligations are easy to see.
This skill targets **Bend 2.0.39**, source revision
`295e996574573e3a88827b1cf7045b437333c8f0`. Treat syntax and APIs as versioned.

## Establish the language first

1. Inspect the project's instructions, `.bend` files, toolchain pin and laws.
2. Run `bend version`, `bend --help`, and `bend guide`. Inspect the needed names
   with `bend base NAME`; do not invent an API from a familiar language.
3. If these identify another generation (for example HVM, `bend run`, `bend
   run-c`, `bend run-cu`, `fold`, or the old `bend` loop construct), stop applying
   this guide's syntax. Report the mismatch and use that project's own docs.
4. On a different Bend 2 release, compare its guide and Base signatures, then
   recheck examples. If no compiler is available, label code **unverified**.

## Work in small checked steps

- Start from the invariant: state what must hold and over which inputs. For new
  proof-bearing code, write `LAWS.bend` before the implementation and proof.
  Check whether a useless implementation could satisfy the proposed laws.
- Read existing laws before changing behavior. Keep `LAWS.bend` fixed unless the
  user explicitly requests a specification change. Fix code or proofs instead
  of weakening claims, adding assumptions, holes, or `@unsafe` to pass a check.
- Keep computation pure; put effects in a thin `IO` boundary. Use domain
  constructors for meaningful alternatives, and `Maybe`/`Result` for failure.
- Write explicit parameter and result types. Use two-space indentation and
  descriptive snake_case function names, following the local code. These are
  this project's style choices, not a published universal Bend style standard.
- Put shrinking arguments before changing accumulators. Match on parameters or
  pattern fields, in binder order. Give a computed value to a helper before
  matching it; binding it with `=` does not remove this restriction.
- Treat ordinary bindings as affine. Add `+` only where a `Data` value really
  needs reuse. Arrays, handles and runtime closures cannot become reusable by
  adding `+`. Use closed templates or top-level defs for repeated operations.
- Annotate operators, for example `(price * units : U32)`. Use `T.is_eq` for
  runtime equality; `{a == b : T}` states a proposition.
- Preserve behavior during a refactor, including failures, numeric bounds and
  resource ownership. State any intentional signature or behavior change.
- When composing Base APIs, inspect quantities as part of callback types. A
  reusable parameter may need an affine lambda adapter. Check imported names
  before introducing domain constructors; aliases do not prevent collisions.

## Load only what the task needs

| Task | Read |
|---|---|
| Types, quantities, matching, recursion, templates, anti-patterns | [Core idioms](references/core.md) |
| Specifications, induction, proof failures, trust boundaries | [Laws and proofs](references/proofs.md) |
| Callback quantities, names, numeric/text contracts, API composition | [Composition](references/composition.md) |
| Parsing, IO, resource ownership, array indexing | [Effects and arrays](references/effects-and-arrays.md) |
| Fork/join, CPU vs GPU vs JS, performance review | [Parallelism](references/parallelism.md) |
| Version disputes, evidence, upstream code and licenses | [Sources](references/sources.md) |
| Complete working code | [Example index](references/examples.md) |

## Validate before handing back

1. Run `bend changed.bend --check-only` for affected entry points and imports.
   Require successful exit status **and** `ALL PROOFS CHECK`. Read diagnostics;
   a normal run with a `main` is not the same proof gate.
2. If the project has laws, run `bend PROOF.bend`; ensure it imports the real
   `LAWS.bend` and has no `main` that substitutes a program run for the verdict.
   Run `bend PROOF.bend --verdict` when the pinned BendTT/Lean toolchain is
   available. Report a skipped or failed kernel check distinctly.
   On a temporary copy, introduce a relevant implementation defect and confirm
   the unchanged laws reject it. A surviving mutation exposes the contract's
   limits; do not hide it or claim a property the law does not state.
3. Exercise success, empty, malformed and relevant boundary inputs. Compile and
   run on the intended backend: `bend app.bend -o app` for native, or
   `bend app.bend -o app.js` followed by `node app.js` for JS. JS does not validate
   CPU parallelism or GPU execution. Do not invent `bend test`, `fmt` or `lint`.
   Some F32 primitives remain symbolic during normalization in this pin;
   concrete output assertions need a compiled backend.
4. Report the exact toolchain, commands and results. Separate checker acceptance,
   runtime tests, kernel verification and style recommendations. Never infer a
   speedup or whole-program correctness from a passing fixture or a written law.

When a check fails, minimize the failing function, inspect its Base signatures,
and explain the actual diagnostic before changing the design.
