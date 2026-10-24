# Proof and expected-rejection partition findings

Toolchain: `/tmp/beautiful-bend-bin/bend`, `bend 2.0.39`; authoritative source/guide/Base snapshot `/tmp/beautiful-bend-upstream`, revision `295e996574573e3a88827b1cf7045b437333c8f0`.

## Scope and contract design

This partition contains exactly 15 proof cases (`p01`–`p15`) and 25 expected rejections (`n01`–`n25`). It preserves the existing counter project as p01 and the existing nine negative entries in their original order. Fourteen new proof projects each contain `LAWS.bend`, `model.bend`, and `PROOF.bend`; sixteen new rejection entries exercise language rules. The manifest lists every auxiliary file, including the foreign source, and excludes files already listed as cases from support.

All fourteen new law files were written in a separate first pass before writing any implementation or proof. Design scope was chosen beforehand: unbounded Nat arithmetic; finite latch/traffic/workflow models with no IO, time, or concurrency claims; optional values with a domain-specific missing/found encoding; ordered lists without sorting claims; binary-tree mirror structure; equality transport; and an existential predecessor witness. These deliberately small contracts are independent intended properties, not whole-application correctness claims. No claim was weakened after a failing proof.

A subsequent parent request added law hashes after the first checker sweep. The manifest now records `law_file` and SHA256 for every proof. These hashes were not captured before the first implementation pass; this timing is explicit rather than retroactively claimed. All original new law contents were retained except the authorized mechanical constructor-name correction below. Existing law files were never edited.

## Specification spelling correction

The initial p12 model used `Done`, which collides with Base.Result’s globally unique constructor. The checker reported `a fresh constructor name (duplicate declaration: Done)`. Omitting the model’s Base import did not remove the collision because the proof project still imports Base. The parent explicitly authorized renaming the new contract’s constructor to `Finished` while preserving both predicates and all quantifiers. This correction preceded freezing the final manifest hash.

```diff
-  {Model.step(Model.Done{}) == Model.Done{} : Model.State}
+  {Model.step(Model.Finished{}) == Model.Finished{} : Model.State}
```

Original p12 law SHA256: `4c913296e263b0879de6011895918760f83192ea7fecf30019a1127364f0acd6`.
Final p12 law SHA256: `3655d6027ca4e7dcb3f3ad219d8f289b2a02c46bbefd6227be2e594dcbf6fc9c`.

## Initial failures and corrections

| Check | Initial result | Correction |
|---|---|---|
| p09 map length | `expected : List<&2, Nat>` / `observed : Nat` | Parenthesized `(1n+h)` before list cons; the law stayed fixed. |
| p12 workflow | Duplicate constructor `Done` | Authorized mechanical `Finished` rename as documented above. |
| p14 mirror | Rewrite motive produced a different branch equality | Kept the first rewritten subtree in its computed form in the second motive; laws and implementation stayed fixed. |
| n13 order | Initial example unexpectedly accepted | A later parameter may be matched when earlier parameters are only used. Changed the fixture to attempt matching the earlier binder after the later match, which is the actual prohibited action. |
| n21 false induction | First rewrite motive itself mismatched the goal | Used `Equal.sym` on the induction hypothesis so the rejected step is the actual false constructor equality. |
| n22 foreign | Non-IO foreign signature failed before dependency check | Changed the foreign definition and caller to `IO(Nat)`; the intended foreign dependency guard then rejected both. No foreign code was executed. |

The second full proof sweep fixed p09 but still rejected p12 and p14. Focused corrections then accepted each. The final sweep below checks all cases again.

## Skill gaps supported by the experiments

- “Match in binder order” needs nuance: skipping an earlier binder is allowed if it is never subsequently scrutinized. Returning to it after a later match is rejected (n13).
- Constructor names are globally unique across imported modules; aliases do not make a `Done` constructor safe to redeclare beside Base.
- Nat successor syntax needs parentheses when used as a list head before `<>`; otherwise its parse/type differs from the intended list construction.
- A rewrite motive substitutes the equality’s right side at `_` in the current goal and leaves the left-side substitution as the next obligation. Sequential constructor rewrites must preserve unreduced computed terms consistently.
- User foreign definitions must return base `IO(...)` directly; testing the trust guard requires first satisfying that signature restriction.

These findings were recorded here; the shared skill and its references were not edited by this partition.

## Actual execution counts

| Phase | Proof --check-only | Plain PROOF run | Rejection --check-only |
|---|---:|---:|---:|
| Initial full sweep | 15 (12 accepted, 3 failed) | 0 | 25 (24 rejected, 1 unexpectedly accepted) |
| Second full proof sweep | 15 (13 accepted, 2 failed) | 0 | 0 |
| Focused corrections | 2 accepted | 0 | 3 rejected at intended rule |
| Final complete sweep | 15 accepted | 15 accepted | 25 rejected at intended rule |
| Total invocations | 47 | 15 | 53 |

**115 Bend entry-point invocations total.** Of the initial 24 rejection exits, n21/n22 were not yet reaching their intended final rejection point. The final 55 invocations all met their precise predicates. Version/Base introspection is separate from these counts.

Commands for every final proof case:

```sh
/tmp/beautiful-bend-bin/bend PATH/PROOF.bend --check-only
/tmp/beautiful-bend-bin/bend PATH/PROOF.bend
```

Both commands required exit 0 and `ALL PROOFS CHECK`. None of the proof entry points has a `main`. Each negative was run only with `--check-only`, requiring exit 1, `SOME PROOFS FAIL`, and its manifest diagnostic substring. Final validation additionally checked all 15 law hashes, unique case IDs, complete file accounting, and no case/support overlap.

## Final proof evidence

| ID | Project | Check-only | Plain proof |
|---|---|---|---|
| p01 | proofs/counter | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p02 | proofs/toggle | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p03 | proofs/latch | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p04 | proofs/traffic_cycle | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p05 | proofs/addition_associativity | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p06 | proofs/replicate_length | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p07 | proofs/append_identity | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p08 | proofs/append_length | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p09 | proofs/map_length | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p10 | proofs/optional_roundtrip | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p11 | proofs/clamp_one | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p12 | proofs/workflow_reset | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p13 | proofs/equality_transport | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p14 | proofs/tree_mirror | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |
| p15 | proofs/predecessor_witness | exit 0; ALL PROOFS CHECK | exit 0; ALL PROOFS CHECK |

## Final rejection evidence

Each row exited 1 and printed `SOME PROOFS FAIL` plus the following stable diagnostic.

| ID | Rule | Required diagnostic substring |
|---|---|---|
| n01 | rejections/structural_argument_order | `a decreasing self-call` |
| n02 | rejections/computed_match | `a parameter or field scrutinee` |
| n03 | rejections/computed_destructure | `a parameter or field scrutinee` |
| n04 | rejections/array_copy | `+cells can be used many times, so its type must be Data` |
| n05 | rejections/false_equality | `expected : 0n` |
| n06 | rejections/closure_reuse | `consumed more than once` |
| n07 | rejections/unsafe_dependency | `defs that depend on @unsafe: loop` |
| n08 | rejections/operator_annotation | `a type for this operator` |
| n09 | rejections/open_law | `not a valid proof yet` |
| n10 | rejections/erased_runtime | `expected : -secret` |
| n11 | rejections/data_closure_field | `expected : Data` |
| n12 | rejections/nonexhaustive | `cases for False` |
| n13 | rejections/match_binder_order | `'first' can't be matched in this position` |
| n14 | rejections/local_match | `a match cannot scrutinize a local binder` |
| n15 | rejections/template_capture | `a template applied to closed ~ arguments` |
| n16 | rejections/template_order | `only leading binders take ~` |
| n17 | rejections/forward_reference | `a filled definition` |
| n18 | rejections/mutual_recursion | `a filled definition` |
| n19 | rejections/unchanged_recursion | `a decreasing self-call` |
| n20 | rejections/proof_hole | `observed : ?unfinished_induction` |
| n21 | rejections/false_induction | `expected : 1n` |
| n22 | rejections/foreign_dependency | `defs that depend on foreign effects: external, answer` |
| n23 | rejections/laws_import_guard | `PROOF.bend must import ./LAWS.bend` |
| n24 | rejections/duplicate_template_binder | `a fresh ~ binder name` |
| n25 | rejections/erased_field_runtime | `expected : -secret` |

## Limits and remaining blocker

These results establish ordinary checker acceptance and exact expected rejection behavior for the pinned compiler. They do not establish kernel verification. `--verdict` was not retried: the parent reported an existing read-only home/toolchain blocker, no Lean installation, and an official installer HTTP 403 denial. This partition performed no installation, network request, commit, push, or unsafe/foreign execution. No proof or rejection work remains blocked; only the separate kernel-verification capability remains unavailable.
