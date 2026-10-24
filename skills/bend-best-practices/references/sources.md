# Sources and scope

Reviewed **2026-10-24**. Start with [bend-lang.com](https://bend-lang.com/), which
identified v2.0.39 and linked to `bendlang/bend/guide/GUIDE.md`. The cloned source
agreed: `bend version` printed `bend 2.0.39`. This is the current affine,
dependently typed Bend 2 language, not an assumption based on old HVM tutorials.

## Pinned primary evidence

All Bend paths below are pinned to
`295e996574573e3a88827b1cf7045b437333c8f0`:

The user also supplied [the official implementation repository](https://github.com/bendlang/bend/tree/main).
On 2026-10-24 its `main` resolved to this same revision (commit title
“The flake names 2.0.39 (#1841)”, dated 2026-10-23). The 100-case suite kept the
existing compiler pin throughout; no newer-main syntax was mixed into it.

| Source | Used for |
|---|---|
| [GUIDE.md](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/guide/GUIDE.md) | Syntax, quantities, matching, recursion, templates, IO, array semantics, proof conventions, targets |
| [base.bend](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/bend2/base.bend) | Exact kinds, constructors and signatures for List, Maybe, Result, Array, IO, numeric operations |
| [main.ts](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/bend2/main.ts) | Version, flags, proof verdicts, mandatory law import, native compiler requirements |
| [bend.ts](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/bend2/bend.ts) | Parser/checker implementation and language restrictions |
| [comp.ts](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/bend2/comp.ts) | C/JS compiler and runtime; emitted JS was exercised locally |
| [safe.ts](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/bend2/safe.ts) | Kernel translation/check path and Lean 4.34.0 dependency |
| [computed-match regression](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/tests/check/computed_match_split.bend) | Expected refusal of computed matches |
| [array statement regression](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/tests/flatten/array_statement.bend) | Helper parameters for destructuring computed reads |
| [U32 native/model regression](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/tests/base/u32_native_model.bend) | Boundary and wraparound semantics, cross-target checking |
| [Base collection tests](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/tests/base/map_set_array_kit.bend) | Array/library usage and expected-output testing convention |
| [parallel sum demo](https://github.com/bendlang/bend/tree/295e996574573e3a88827b1cf7045b437333c8f0/demos/pure_par_sum) | Fork/join decomposition and separately stated/proved laws |
| [hello-world demo](https://github.com/bendlang/bend/tree/295e996574573e3a88827b1cf7045b437333c8f0/demos/io_hello_world) | Small IO program and paired proof files |

The site also links the [BendTT](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/paper/BendTT.pdf)
and [BendRT](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/paper/BendRT.pdf)
papers. They are further reading, not papers independently audited for this
skill. The compiler's success messages and the website's performance claims
are not adopted as blanket correctness or speed guarantees.

## Teaching and packaging inspiration

[BeautifulRust](https://github.com/morganlinton/BeautifulRust/tree/6b3a96c57c033fd13d91507b7c9af6865ab02efa)
by Morgan Linton, v1.1.0, MIT: studied its skill, source digests, plugin and
marketplace manifests, README, and evaluation layout. Adopted the architectural
ideas of one discoverable skill, focused references, a handback checklist,
and realistic evaluation tasks. This project uses shorter task-oriented Bend
references and tool-independent JSON evaluations. It does not port Rust's borrow
checker, traits, Cargo, clippy, async, or panic rules.

Language guidance and examples were written for this project. Bend upstream is
[Apache-2.0](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/LICENSE);
the source is read/downloaded for validation, not vendored in the skill.
No upstream prose digests or Bend demo files are redistributed verbatim.
BeautifulRust's MIT notice is retained in the bundled
[third-party notice](../THIRD_PARTY_NOTICES.md). This skill's own license is
[MIT](../LICENSE).

## Resolve disagreements with evidence

Prefer the installed, pinned toolchain and matching Base implementation over
older examples or remembered syntax. If documentation and compiler disagree,
keep a minimal reproducer and label the difference; do not silently generalize
a workaround across versions. Our computed-array-destructure negative fixture
and helper-based positive example record one such easily misread restriction.
Project style choices are recommendations; compiler-accepted examples only
establish the checks listed in the validation report.

## Package-resolution evidence

[The modules section](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/guide/GUIDE.md#modules),
[resolver code](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/bend2/bend.ts#L898),
and [publish/link implementation](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/bend2/main.ts#L650)
ground the [package reference](packages.md). The [live hub guide](https://hub.bend-lang.com/guide)
was read on 2026-10-24. Its package pages and the fresh-cache named-import probe
could not supply dependency content in this environment. No external package
source, license or content hash has therefore been verified or redistributed.
