# Evaluating the skill

[cases.json](cases.json) contains six tool-independent tasks and observable
rubrics: fresh implementation, an affine refactor, law-preserving repair,
performance review, and language-generation detection. These are not claimed
to implement any vendor's `plugin eval` schema.

For each case, start a fresh agent/session in a temporary directory. Copy only
the listed `inputs` into that directory (for the counter case, place the three
files together at its root). Give the agent the skill, the `prompt`, and the
same compiler/tool access used for other runs. Keep this file, the rubrics,
prior outputs, and repository tests out of its context. Do not give it expected
answers. Limit the run to local artifacts and checks; no publication or installs.

After completion, a reviewer scores each rubric item as pass/fail with a file,
command, or transcript citation. Inspect the actual generated code; don't grade
only the final narrative. Run produced programs, compare observable outputs,
and compare the law file byte-for-byte. Record tool failures as blockers rather
than language or model failures. A failed required correctness or law-integrity
criterion fails the case even if its style looks good.

To measure benefit, repeat all cases with and without the skill using the same
model, prompt, budget, and toolchain. Use multiple fresh runs and report raw
counts and failures. Compilation fixtures are not model evaluations. One
successful run is not a controlled improvement claim.

Initial evidence: one fresh **gpt-6-astra** agent completed `parse-quantities`
with the skill. The task included an output directory and executable location,
but not the rubric or expected answers. See
[the dated record](results/2026-10-24.md). A second, novel law-preserving repair task ran with the expanded skill; see
[the 100-suite evaluation record](results/2026-10-24-100.md). The original four
remaining tasks and a no-skill baseline have not been run. Neither task counts
toward the 100 compiler/runtime cases.
