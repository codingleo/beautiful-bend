# Fixed-law mutation checks

The user emphasized that LAWS and proofs are foundational. These supporting checks make that claim observable: each proof project is copied to a temporary directory, one meaningful implementation/proof defect is introduced in the copy, and the original law must cause rejection. They add **zero suite cases**; the finite suite remains 100 cases.

## Deliverable and preservation

`tests/proof-mutations.json` contains exactly `m01`–`m15`, one for each `p01`–`p15`. Each mutation records its repository-relative target, exact unique old/new text, purpose, and an observed diagnostic. No valid model, proof, or LAWS file was edited. The original p01 project was copied in full from `examples/laws`, including `counter.bend`, `LAWS.bend`, `PROOF.bend`, and `main.bend`; the other fourteen projects were copied in full from their own directories. Relative imports therefore resolve to the copied support files. Base remains the pinned compiler library.

Before testing each mutation, the original LAWS SHA256 was compared with the frozen proof-case manifest. Copied LAWS bytes were compared directly with the original after the mutation. Hashes of all original project files were captured before discovery and checked afterward. The manifest-driven replay also checked every law hash. All checks passed.

## Method and actual counts

Compiler: `/tmp/beautiful-bend-bin/bend`, version 2.0.39. Every invocation used `--check-only`; neither unsafe/foreign code nor a runtime main was executed. The mutation target was required to contain `old` exactly once.

Discovery performed these commands for each temporary project:

```sh
/tmp/beautiful-bend-bin/bend /tmp/bend-law-mutations-<id>/mNN/PROOF.bend --check-only
# For the 13 implementation mutations only:
/tmp/beautiful-bend-bin/bend /tmp/bend-law-mutations-<id>/mNN/model.bend --check-only
# p01 uses counter.bend instead of model.bend.
# Then check PROOF.bend again after mutating the copied file:
/tmp/beautiful-bend-bin/bend /tmp/bend-law-mutations-<id>/mNN/PROOF.bend --check-only
```

The first command required exit 0 plus `ALL PROOFS CHECK` before mutation. The standalone mutated model check also required exit 0 plus `ALL PROOFS CHECK`, proving that all thirteen implementation defects remain valid Bend programs. The mutated proof check required exit 1 plus `SOME PROOFS FAIL`, with the error located in the corresponding `Laws.*` proof. Thus an unrelated syntax, quantity, termination, import, or type error in the model could not count as a caught mutation.

An independent replay read the saved JSON and recreated every temporary project, required unique replacement text and unchanged LAWS, then checked:

```sh
/tmp/beautiful-bend-bin/bend /tmp/bend-mutation-replay-<id>/mNN/PROOF.bend --check-only
```

Replay required exit 1, `SOME PROOFS FAIL`, and the exact saved diagnostic substring. All fifteen passed.

| Phase | Checks | Result |
|---|---:|---|
| Unmutated proof baselines | 15 | 15 accepted |
| Standalone mutated implementations | 13 | 13 accepted |
| Mutated proofs, diagnostic discovery | 15 | 15 rejected at original law |
| Saved-manifest replay | 15 | 15 expected rejections |
| Total | 58 | All expected outcomes |

These are **58 additional checker invocations**, separate from the 115 partition-development invocations recorded in `proofs-rejections.md`. No mutation failed to trigger its intended proof rejection on the first discovery pass; no alternate candidates or discarded runs are omitted.

## Why each rejection matters

| Mutation | Original invariant and counterexample | Diagnostic proof location |
|---|---|---|
| m01 / p01 | With zero steps and balance 0, the mutant returns 1; zero_steps requires 0. | `Laws.zero_steps` |
| m02 / p02 | For False, two mutant toggles produce True instead of False. | `Laws.involution` |
| m03 / p03 | For False, the mutant setter returns False; established requires True. The idempotent law alone would not detect this defect. | `Laws.established` |
| m04 / p04 | From Red, three mutant transitions produce Green instead of Red. | `Laws.cycle` |
| m05 / p05 | The mutant computes 2*a+b: at (a,b,c)=(1,0,0), the associative sides are 4 and 2. | `Laws.associative` |
| m06 / p06 | At n=1, the mutant batch is empty (length 0) although exact_length requires 1. | `Laws.exact_length` |
| m07 / p07 | Appending [] to [1] becomes [0], so right_identity fails even though length is unchanged. | `Laws.right_identity` |
| m08 / p08 | Appending [1] to [] becomes []; length_sum requires 1 rather than 0. | `Laws.length_sum` |
| m09 / p09 | At xs=[0], the mutant map returns [] and changes length from 1 to 0. | `Laws.length_preserved` |
| m10 / p10 | Encoding and decoding Some{0} produces Some{1} instead of the original payload. | `Laws.roundtrip` |
| m11 / p11 | At n=2, the mutant is predecessor: two applications yield 0 while one yields 1. | `Laws.idempotent` |
| m12 / p12 | From Idle, step produces Running, and mutant reset leaves Running; reset_after_step requires Idle. | `Laws.reset_after_step` |
| m13 / p13 | The replacement term proves {b == a : Nat}; the unchanged goal is {1n+a == 1n+b : Nat}. This is a proof defect, not a false law or changed model. | `Laws.ticket_congruence` |
| m14 / p14 | For Leaf{0}, two mutant mirrors produce Leaf{2}, so the original tree is not restored. | `Laws.involution` |
| m15 / p15 | The fixed witness 0 has predecessor 0; at n=1 it cannot witness the required equation. | `Laws.successor_exists` |

## Proof scope and specification limits

The thirteen implementation mutations violate actual semantic properties of their unchanged laws, as the counterexamples above show. Some inductive proofs fail first at their rewrite motive because the mutant no longer has the law-preserving constructor shape; this is a relevant failure of the existing proof obligation, not evidence that a syntax error was caught. Counterexamples independently establish that those mutated properties are false.

p13 is deliberately a proof mutation: congruence holds for every well-typed pure ticket function. Its law cannot distinguish successor numbering from a different pure numbering policy. The check catches substituting symmetry of the input equality for congruence of the outputs; it does not claim to detect a ticket-policy implementation defect. p15 deliberately tests an incorrect existential witness. Its formal law asks for a predecessor preimage of each n; it does not require witness uniqueness or separately constrain predecessor behavior at zero.

Other laws also specify the named invariant rather than uniquely determining an entire implementation:

- p01 fixes zero steps and empty starting balance; it does not independently characterize every pair of nonzero inputs.
- p02 involution also permits identity; p04 three-step restoration does not by itself require visiting three distinct phases.
- p05 associativity alone does not characterize Nat addition; other associative operations satisfy it.
- p07 right identity constrains empty suffixes; p08 length addition does not constrain elements or order.
- p09 length preservation does not prove that payloads were incremented correctly.
- p10 roundtrip permits alternative reversible encodings.
- p11 idempotence plus zero preservation permits identity and constant-zero implementations; it does not fully characterize saturation at one.
- p12 proves reset after a step and terminal-state absorption, without completely specifying every transition.
- p14 involution alone also permits identity; it does not uniquely characterize mirroring.

These are recorded coverage limits, not silently altered contracts. No laws were weakened or expanded to obtain a passing mutation result. More complete behavioral specifications need additional explicit requirements and proof obligations.

## Verification boundary

All results are ordinary checker results for Bend 2.0.39, not kernel verification. No `--verdict` retry, installation, network access, commit, or push was performed. There are no blockers for these mutation checks.
