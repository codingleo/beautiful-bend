# Example index

All examples target Bend **2.0.39** at the revision in [sources](sources.md).
The repository's `tests/cases.json` records exact expected output and
`scripts/validate.py` checks it. See root `VALIDATION.md` for the dated run.

| File | Teaches | Expected result |
|---|---|---|
| [invoice.bend](../examples/invoice.bend) | Domain constructors, small helpers, shrinking list before accumulator | `(0, 390)` |
| [quantities.bend](../examples/quantities.bend) | Minimal `+`, closed `List.map` template | `(49, [1, 10, 42])` |
| [parsing.bend](../examples/parsing.bend) | `Maybe` composition, matching through a helper, valid zero | `("42", "invalid number", "0")` |
| [effects.bend](../examples/effects.bend) | Pure computation with a thin IO shell, local import | Two lines: `42`, `invalid number` |
| [arrays.bend](../examples/arrays.bend) | Owner threading, computed-pair helpers, wraparound | `(17, 17)` |
| [parallel_tree.bend](../examples/parallel_tree.bend) | Fork/join on a balanced fixture | `10` |
| [laws/main.bend](../examples/laws/main.bend) | Pure counter boundary samples | `(9n, 7n)` |
| [laws/LAWS.bend](../examples/laws/LAWS.bend) and [laws/PROOF.bend](../examples/laws/PROOF.bend) | Separate claims and reflexive/inductive proofs | `ALL PROOFS CHECK` from the ordinary checker |

The seven runnable examples were emitted to JavaScript and executed. The six
pure mains also ran by checker normalization. The proof gate passed the ordinary
checker. Native execution, GPU execution and BendTT kernel verification have
**not** been established by these checks. Style recommendations have no compiler
certificate. Examples are original teaching fixtures, not production libraries.
