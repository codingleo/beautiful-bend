# Parallelism without performance folklore

Scope: Bend 2.0.39. Sources: the pinned guide's Parallelism/Tooling sections,
`bend2/comp.ts`, and `demos/pure_par_sum/` linked in [sources](sources.md).

Use `a b = f(x) g(y)` to express two independent pure calls before combining
their results. Favor a decomposition with similar work on both branches.
[parallel_tree.bend](../examples/parallel_tree.bend) demonstrates the notation
over a balanced input. The `Tree` type does not require balance; a skewed input
is still possible and may be a poor parallel workload.
The expanded [balanced](../examples/suite/systems/balanced_checksum.bend),
[skewed](../examples/suite/systems/skewed_statistics.bend) and
[empty](../examples/suite/systems/empty_workload.bend) fixtures compare with
sequential definitions and independent arithmetic expectations. Their JS runs
test decomposition correctness on those samples, not parallel scheduling.

Do not parallelize by duplicating useful work or adding tasks to a trivial
operation just to show the syntax. A sequential list fold is often clearer
than forcing a tree conversion solely for a small aggregation. These are
design recommendations, not measured break-even thresholds.

## Separate target behavior

| Path | What it does | What a successful run establishes |
|---|---|---|
| `bend value.bend` with a pure main | Checker normalization; some primitives stay symbolic | Normalized result where supported, not native performance |
| `bend app.bend -o app`; run `./app` | Native CPU executable | Behavior on that host/configuration |
| `f!(x)` in a native build | GPU-marked call; CPU fallback without a GPU | Only the backend actually observed |
| `bend app.bend -o app.js`; run Node | JavaScript; parallel calls run sequentially | JS behavior, not scheduling or GPU behavior |

An IO main normally runs compiled. The current native toolchain requires
clang 14+; a program using `!` requires clang 19+ (Apple clang 17), plus the
appropriate GPU toolchain. A generated `.gpu` file must accompany its binary.
On Linux the guide names CUDA 12/13; on macOS it names Metal. Verify the
installed guide before giving platform-specific setup instructions.

Read `bend guide shaders` before substantial GPU work, while recognizing its
upstream AI-authored status. Shared reusable values and an uneven work split
can change costs. Do not repeat headline C-speed, zero-copy, linear-scaling,
or GPU speedup claims as guarantees for the user's program.

## Measure the user's workload

First pin correctness against a sequential/reference result. Then record the
compiler revision, target, CPU/GPU, input shape and size, thread settings, and
timing method. Separate compilation from execution and include warmup where
needed. Compare representative balanced and skewed inputs and repeat runs.

`./app +RTS --threads 8` selects eight CPU threads. Use the installed CLI/runtime
help for supported settings. Confirm which backend ran; CPU fallback is not
evidence of GPU execution. No timing measurements or speedup claims are bundled
in this skill's initial validation.
