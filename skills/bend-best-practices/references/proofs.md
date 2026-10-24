# Laws and proofs

Scope: Bend 2.0.39; see the pinned [sources](sources.md). Treat laws as the
specification and proofs as an implementation obligation, not as a replacement
for deciding whether the specification expresses the user's intent.

## Keep the contract separate

- `counter.bend`: the pure implementation.
- `LAWS.bend`: imports that implementation and declares claims with `law`.
- `PROOF.bend`: imports `LAWS.bend as Laws` and fills each with
  `def Laws.name(...)`.
- `main.bend`: exercises the implementation, separately from the proof gate.

The complete [counter example](../examples/laws/PROOF.bend) proves two claims:
zero steps preserve any balance, and crediting an empty balance produces the
step count. One is definitional equality; the other uses structural induction.
These are narrow claims about `Nat` computations, not a claim about a bank,
persistence, authentication, or an external service.

When implementing an existing contract, read and retain the law file. When
asked to design a new contract, explain the proposed meaning and assumptions.
Do not weaken a failed law, remove an import, silently alter the reference
implementation, or substitute a fixed-input example for a universal claim.
For sorting, for example, sortedness alone permits returning an empty list;
preservation of elements is a separate obligation.

## Build a proof one constructor at a time

`{a == b : T}` is a type. `{==}` proves it only when both sides reduce to the
same term; it is not an assertion that can make any equation true.

Match on the structural parameter. Close the base case by reduction. In a
recursive case, use a proof on the smaller field as the induction hypothesis.
`%e : P` rewrites using an equality `e`; `_` marks the rewritten position in
the motive `P`. Keep the motive explicit and small enough to read. Check each
step rather than guessing a long sequence of rewrites.

Use `?name` to inspect a goal during development. An open law or `?TODO` is
unfinished work, never a proof. There are no Lean tactics to paste into Bend.
Use the pinned Base definitions of `Equal.sym`, `Equal.trans`, or `Equal.cong`
when appropriate; check their signatures and quantities first.

## Know which check ran

```sh
bend PROOF.bend
bend PROOF.bend --check-only
bend PROOF.bend --verdict
```

The first two produce the ordinary checker verdict when the proof entry has
no `main`. `--check-only` also prevents running an accidentally added main.
Require exit 0 and `ALL PROOFS CHECK`, not merely the absence of a crash.
The CLI refuses a `PROOF.bend` beside a `LAWS.bend` that it does not import.

`--verdict` additionally translates the checked book and checks it with the
BendTT kernel. This pin requires Lean **4.34.0**, or an appropriate prebuilt
kernel selected by `BENDTT`. Do not call ordinary checker acceptance kernel
verification. Report toolchain failures and checker/kernel mismatches directly.

The ordinary gate rejects dependencies on `@unsafe` and user foreign code;
running an unsafe program successfully does not certify its proofs. Base is a
trusted boundary. The translation and runtime are additional trust boundaries:
the guide explicitly says the translation itself is not proven. A kernel check
does not prove that a custom C effect, device driver, network service, or an
unstated requirement behaves correctly.

Keep custom foreign effects outside the pure proof dependency graph when the
law does not concern them. Do not remove a dependency that the law actually
needs to conceal an unproved assumption. Test the IO boundary separately.

## Review questions

Does the law quantify over the intended inputs? Are preconditions justified?
Could a degenerate implementation satisfy it while breaking the request? Does
the proof depend on the implementation under review? Are the real laws imported?
Are any holes, unsafe definitions, foreign assumptions, or kernel failures left?
State these limits alongside the exact check results.
