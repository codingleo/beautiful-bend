# Example index

Bend **2.0.39**, pinned in [sources](sources.md). Generated from the repository
manifest by `scripts/coverage.py`; this index and all linked examples travel
with the standalone skill. The repository adds 25 rejection fixtures, fixed-law
mutations and a repeatable runner. See its `VALIDATION.md` for dated evidence.

## Law and proof projects

Read the law before the implementation or proof. These 15 projects contain 19
law declarations, accepted by the ordinary checker. Each has a targeted
mutation checked by the repository runner. A separate pinned BendTT run accepted
all 15 projects on 2026-10-25, with valid/invalid direct kernel controls.
This establishes the named invariants only, not all runtime behavior;
see [proof scope](proofs.md#use-laws-to-drive-the-implementation).

| ID | Invariant / obligation | Specification | Proof |
|---|---|---|---|
| p01 | Zero credit steps preserve balance; crediting empty balance counts steps. | [LAWS](../examples/laws/LAWS.bend) | [PROOF](../examples/laws/PROOF.bend) |
| p02 | Toggling twice restores every Boolean state. | [LAWS](../examples/suite/proofs/toggle/LAWS.bend) | [PROOF](../examples/suite/proofs/toggle/PROOF.bend) |
| p03 | Setting a latch is idempotent and always establishes True. | [LAWS](../examples/suite/proofs/latch/LAWS.bend) | [PROOF](../examples/suite/proofs/latch/PROOF.bend) |
| p04 | Three transitions restore each traffic signal phase. | [LAWS](../examples/suite/proofs/traffic_cycle/LAWS.bend) | [PROOF](../examples/suite/proofs/traffic_cycle/PROOF.bend) |
| p05 | Grouping unbounded Nat additions preserves the sum. | [LAWS](../examples/suite/proofs/addition_associativity/LAWS.bend) | [PROOF](../examples/suite/proofs/addition_associativity/PROOF.bend) |
| p06 | A batch of n identical units contains exactly n elements. | [LAWS](../examples/suite/proofs/replicate_length/LAWS.bend) | [PROOF](../examples/suite/proofs/replicate_length/PROOF.bend) |
| p07 | Appending an empty suffix preserves all list elements. | [LAWS](../examples/suite/proofs/append_identity/LAWS.bend) | [PROOF](../examples/suite/proofs/append_identity/PROOF.bend) |
| p08 | Concatenation adds list lengths. | [LAWS](../examples/suite/proofs/append_length/LAWS.bend) | [PROOF](../examples/suite/proofs/append_length/PROOF.bend) |
| p09 | Incrementing every list entry preserves its length. | [LAWS](../examples/suite/proofs/map_length/LAWS.bend) | [PROOF](../examples/suite/proofs/map_length/PROOF.bend) |
| p10 | Encoding optional Nat into a domain outcome and decoding preserves absence and payload. | [LAWS](../examples/suite/proofs/optional_roundtrip/LAWS.bend) | [PROOF](../examples/suite/proofs/optional_roundtrip/PROOF.bend) |
| p11 | Saturating a Nat count at one is idempotent and preserves zero. | [LAWS](../examples/suite/proofs/clamp_one/LAWS.bend) | [PROOF](../examples/suite/proofs/clamp_one/PROOF.bend) |
| p12 | Reset after any bounded workflow step establishes the idle state. | [LAWS](../examples/suite/proofs/workflow_reset/LAWS.bend) | [PROOF](../examples/suite/proofs/workflow_reset/PROOF.bend) |
| p13 | Equal counts yield equal successor ticket numbers. | [LAWS](../examples/suite/proofs/equality_transport/LAWS.bend) | [PROOF](../examples/suite/proofs/equality_transport/PROOF.bend) |
| p14 | Mirroring a binary tree twice restores its entire structure. | [LAWS](../examples/suite/proofs/tree_mirror/LAWS.bend) | [PROOF](../examples/suite/proofs/tree_mirror/PROOF.bend) |
| p15 | Every Nat has a successor whose predecessor recovers the original value. | [LAWS](../examples/suite/proofs/predecessor_witness/LAWS.bend) | [PROOF](../examples/suite/proofs/predecessor_witness/PROOF.bend) |

## Runtime programs

All 60 programs require checker acceptance, JS emission and exact Node output.
53 also assert normalization output. Five IO programs and two F32 programs
use compiled execution for concrete results. These sample assertions do not
prove universal correctness, native/GPU execution or performance.

| ID | Program / purpose | Exact stdout (line breaks shown as `\n`) |
|---|---|---|
| r01 | [invoice](../examples/invoice.bend) — Sum priced and complimentary invoice lines, including empty input. | `(0, 390)\n` |
| r02 | [quantities](../examples/quantities.bend) — Duplicate a Data number and apply a closed map template. | `(49, [1, 10, 42])\n` |
| r03 | [main](../examples/laws/main.bend) — Execute the implementation used by the separate counter laws. | `(9n, 7n)\n` |
| r04 | [shipment](../examples/suite/core/shipment.bend) — Use nested domain constructors to distinguish free, standard, and express shipping. | `(0, 2, 3, 9, 14)\n` |
| r05 | [gate_transitions](../examples/suite/core/gate_transitions.bend) — Exhaustively match two domain inputs to implement a gate transition table. | `(Opened{}, Closed{}, Opened{}, Closed{}, Closed{})\n` |
| r06 | [compound_growth](../examples/suite/core/compound_growth.bend) — Use shrinking Nat periods before a changing U32 accumulator. | `(5, 10, 40, 0)\n` |
| r07 | [expression_eval](../examples/suite/core/expression_eval.bend) — Evaluate a recursive domain AST with two different binary operators. | `(0, 9, 20, 14)\n` |
| r08 | [stock_boundaries](../examples/suite/core/stock_boundaries.bend) — Contrast natural stock depletion with machine-word wraparound. | `(0n, 0n, 2n, 4294967295, 0)\n` |
| r09 | [checked_add](../examples/suite/core/checked_add.bend) — Reject overflowing U32 addition before performing it. | `(Fits{0}, Fits{4294967295}, Fits{4294967295}, Overflow{}, Overflow{})\n` |
| r10 | [checked_multiply](../examples/suite/core/checked_multiply.bend) — Handle zero separately and reject overflowing U32 products. | `(Fits{0}, Fits{0}, Fits{4294967295}, Fits{4294967295}, Overflow{})\n` |
| r11 | [erased_generic_swap](../examples/suite/core/erased_generic_swap.bend) — Erase generic types while moving heterogeneous values through a pair helper. | `((3n, 7), (0, False{}), 12)\n` |
| r12 | [erased_data_snapshot](../examples/suite/core/erased_data_snapshot.bend) — Require Data only for the generic operation that actually duplicates its input. | `((0, 0), (Versioned{7}, Versioned{7}), True{}, True{})\n` |
| r13 | [closed_templates](../examples/suite/core/closed_templates.bend) — Reuse closed top-level and lambda operations through a template. | `(6, 10, 12, 0)\n` |
| r14 | [captured_composition](../examples/suite/core/captured_composition.bend) — Compose two affine runtime closures and call each exactly once. | `(6, 14, 11, 12)\n` |
| r15 | [runtime_repeated_offset](../examples/suite/core/runtime_repeated_offset.bend) — Repeat an operation with a runtime Data parameter instead of copying a captured closure. | `(3, 10, 31, 9)\n` |
| r16 | [quarter_units](../examples/suite/core/quarter_units.bend) — Convert Nat unit counts through U32 and exact binary fractions for fixed quarter-unit billing. | `(0, 25, 75, 200, 0n, 17n)\n` |
| r17 | [sensor_clamp](../examples/suite/core/sensor_clamp.bend) — Apply a bounded sensor calibration with computed F32 comparisons passed to helpers. | `(0, 0, 25, 100, 100)\n` |
| r18 | [lexicographic_grid](../examples/suite/core/lexicographic_grid.bend) — Traverse a finite grid with a lexicographically decreasing pair and a resettable column counter. | `(0, 0, 1, 6, 10)\n` |
| r19 | [selective_fields](../examples/suite/core/selective_fields.bend) — Reuse only matched numeric fields while consuming a domain record once. | `((0, 0), (0, 8), 12, 14)\n` |
| r20 | [affine_policy](../examples/suite/core/affine_policy.bend) — Store an affine callback in a Type-kinded domain and consume it through pattern matching. | `(5, 3, 10, 12)\n` |
| r21 | [parsing](../examples/parsing.bend) — Sequence two fallible decimal reads without confusing valid zero with failure. | `("42", "invalid number", "0")\n` |
| r22 | [energy_total](../examples/suite/collections/energy_total.bend) — Map readings to squared energy and sum, including no readings and zero. | `(0, 0, 25)\n` |
| r23 | [ranked_scores](../examples/suite/collections/ranked_scores.bend) — Keep passing scores, sort descending, and cap a leaderboard with duplicates retained. | `([99, 80, 80], [], [], [])\n` |
| r24 | [paired_cost](../examples/suite/collections/paired_cost.bend) — Compute cost of aligned quantities and prices, explicitly truncating unmatched trailing entries. | `(41, 0, 0, 20)\n` |
| r25 | [page_window](../examples/suite/collections/page_window.bend) — Slice a page by offset and length and reverse it for newest-first presentation. | `([40, 30], [50], [], [], [])\n` |
| r26 | [first_available](../examples/suite/collections/first_available.bend) — Choose first adequate stock count and compute unallocated remainder, preserving missing result. | `"2&#124;0&#124;unavailable&#124;unavailable"\n` |
| r27 | [batch_health](../examples/suite/collections/batch_health.bend) — Classify reading batches by existence of a high alarm and universal in-range readings. | `"False/True&#124;False/True&#124;True/True&#124;True/False"\n` |
| r28 | [fold_order](../examples/suite/collections/fold_order.bend) — Build a nested expression with foldr and append a route with foldl to preserve their different argument orders. | `"(a:(b:z))&#124;root/a/b&#124;z&#124;root"\n` |
| r29 | [clean_labels](../examples/suite/collections/clean_labels.bend) — Normalize comma-separated labels by ASCII whitespace trimming, lowercasing, removing empty labels and joining. | `"red/blue&#124;&#124;&#124;two words/green"\n` |
| r30 | [unicode_window](../examples/suite/collections/unicode_window.bend) — Clip and reverse Unicode code points without treating UTF-8 bytes as characters; check list conversion round-trip. | `(4n, 2n, 128578, 0, 2n, True{})\n` |
| r31 | [record_shape](../examples/suite/collections/record_shape.bend) — Accept exactly three delimiter-separated fields while preserving empty field positions and rejecting missing/extra fields. | `"a/b/c&#124;a//c&#124;//&#124;bad fields&#124;a/b/&#124;bad fields"\n` |
| r32 | [decimal_grammar](../examples/suite/collections/decimal_grammar.bend) — Apply explicit decimal token grammar and reject signs, spaces, Unicode digits and U32 overflow. | `"7&#124;0&#124;4294967295&#124;none&#124;none&#124;none&#124;none&#124;none&#124;none"\n` |
| r33 | [service_port](../examples/suite/collections/service_port.bend) — Parse a service port and propagate syntax versus domain-range errors through Result. | `"443&#124;65535&#124;error:range&#124;error:range&#124;error:syntax&#124;error:syntax"\n` |
| r34 | [safe_ratio](../examples/suite/collections/safe_ratio.bend) — Sequence numerator and denominator parsing and reject division by zero with first-error precedence. | `"3&#124;0&#124;error:zero&#124;error:numerator&#124;error:denominator"\n` |
| r35 | [optional_timeout](../examples/suite/collections/optional_timeout.bend) — Prefer explicit seconds, fall back to a default token, convert to milliseconds, then use a final 1000ms default. | `(2000, 3000, 0, 1000, 1000)\n` |
| r36 | [validated_sum](../examples/suite/collections/validated_sum.bend) — Traverse numeric rows with Result, preserving the first invalid row and accepting an empty batch. | `"5&#124;0&#124;error:token=x&#124;error:token="\n` |
| r37 | [recover_rows](../examples/suite/collections/recover_rows.bend) — Recover independently from malformed numeric rows, returning total and rejected-row count. | `"5/1&#124;0/0&#124;0/2&#124;0/0"\n` |
| r38 | [word_counts](../examples/suite/collections/word_counts.bend) — Count repeated string keys using owner-threaded map reads and report absent-key defaults. | `"2/1/0/2&#124;0/0&#124;1/2"\n` |
| r39 | [config_overlay](../examples/suite/collections/config_overlay.bend) — Apply right-hand configuration overrides, remove a retired key, and distinguish an absent key through a supplied default. | `"443/2/5/99/3&#124;99/0"\n` |
| r40 | [canonical_tags](../examples/suite/collections/canonical_tags.bend) — Normalize tags, remove duplicate and empty tags, and render in deterministic sorted order. | `"blue,red&#124;&#124;&#124;a,b"\n` |
| r41 | [arrays](../examples/arrays.bend) — Existing owner-threaded read and wrapping index | `(17, 17)\n` |
| r42 | [effects](../examples/effects.bend) — Existing parsing effects sequence | `42\ninvalid number\n` |
| r43 | [parallel_tree](../examples/parallel_tree.bend) — Existing balanced pure tree sum | `10\n` |
| r44 | [capacity](../examples/suite/systems/capacity.bend) — Distinguish capacity notation and depth including depth zero | `(1, 8, 16)\n` |
| r45 | [string_slots](../examples/suite/systems/string_slots.bend) — Explicit non-U32 get/set preserve untouched slots | `("empty", "ready")\n` |
| r46 | [swap_slot](../examples/suite/systems/swap_slot.bend) — Swap returns old non-U32 element and threads replacement owner | `("queued", "sent")\n` |
| r47 | [clone_independence](../examples/suite/systems/clone_independence.bend) — Mutating cloned arrays leaves other copy independent | `([99, 7, 7, 7], [7, 73, 7, 7])\n` |
| r48 | [map_threshold](../examples/suite/systems/map_threshold.bend) — Map U32 inventory counts to Bool flags including threshold boundary | `[False{}, False{}, True{}, True{}]\n` |
| r49 | [array_inventory](../examples/suite/systems/array_inventory.bend) — Sequential stock withdrawals and restocking preserve all other slots | `[5, 3, 8, 5]\n` |
| r50 | [checked_index](../examples/suite/systems/checked_index.bend) — Reject capacity index before array wrapping can occur | `(Some{8}, None{})\n` |
| r51 | [balanced_checksum](../examples/suite/systems/balanced_checksum.bend) — Balanced position-sensitive checksum agrees with sequential reference | `(1120, True{})\n` |
| r52 | [skewed_statistics](../examples/suite/systems/skewed_statistics.bend) — Skewed tree totals/counts agree with sequential reference | `(15, 3, True{})\n` |
| r53 | [empty_workload](../examples/suite/systems/empty_workload.bend) — Empty branches combine neutral totals/checksums | `(0, 0, True{})\n` |
| r54 | [independent_dependent](../examples/suite/systems/independent_dependent.bend) — Distinguish independent square tasks from dependent square-of-sum pipeline | `((85, True{}), 169)\n` |
| r55 | [io_sequence](../examples/suite/systems/io_sequence.bend) — Deterministic write/print sequencing preserves newlines | `begin:loaded\nvalidated\ncommit:done\n` |
| r56 | [io_pure_bind](../examples/suite/systems/io_pure_bind.bend) — Explicit IO.pure and nested IO.bind pass the previous result | `42\n` |
| r57 | [io_independent](../examples/suite/systems/io_independent.bend) — Independent fork/join results agree with direct sequential calculation | `85\n85\n` |
| r58 | [io_dependent](../examples/suite/systems/io_dependent.bend) — Dependent fork consumes prior joined result and agrees with direct pipeline | `169\n169\n` |
| r59 | [fuel_machine](../examples/suite/systems/fuel_machine.bend) — Bounded fuel respects zero/completed and exact/exhausted boundaries | `(Complete{0}, Paused{1n, 2}, Complete{3})\n` |
| r60 | [state_transitions](../examples/suite/systems/state_transitions.bend) — Inventory command interpreter preserves empty state and counts rejected withdrawal | `(Stock{0, 0}, Stock{1, 1})\n` |
