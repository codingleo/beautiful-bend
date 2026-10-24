# BendHub packages and dependency laws

- [Dependency review](#resolve-a-real-dependency-before-writing-against-it) · [Resolution/cache](#understand-resolution-and-the-cache)
- [Proof boundaries](#keep-dependency-claims-inside-the-proof-boundary) · [Publication](#recognize-publication-commands)

Scope: Bend **2.0.39**, source revision
`295e996574573e3a88827b1cf7045b437333c8f0`. This reference is grounded in the
[module guide](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/guide/GUIDE.md#modules),
[resolver](https://github.com/bendlang/bend/blob/295e996574573e3a88827b1cf7045b437333c8f0/bend2/bend.ts#L898),
and [BendHub guide](https://hub.bend-lang.com/guide). Our package-selection and
review workflow is a recommendation; the syntax and resolver details are
version-specific implementation facts.

**Validation status:** real-package examples are currently blocked by registry
access in the validation environment. No external package source/license audit,
successful registry import, pinned package hash or package-backed proof is
bundled yet. The existing 100 cases exercise Base and local modules only.

## Resolve a real dependency before writing against it

1. Start at the [live registry](https://hub.bend-lang.com/packages). Inspect the
   actual package files, entry point, publisher/provenance, transitive imports
   and license. A description or search snippet does not establish these facts.
2. Record the content hash and any exact registered version, along with
   the compiler revision. Read exported signatures, quantities, errors and laws.
   Prefer a small dependency whose behavior and trust boundaries can be reviewed.
3. Preserve the package's license and required notices when redistributing its
   code. The hub guide states that packages without a `LICENSE` default to MIT-0;
   inspect the package itself before applying that rule. A version label does
   not authenticate the author or establish the code's correctness.
4. Put a narrow wrapper around the API when the application needs stronger
   validation or a different error policy. Write the wrapper's laws first.
   Keep package behavior assumptions explicit rather than silently proving an
   unrelated local model and attributing that result to the dependency.

These are syntax templates, **not existing package identifiers**:

```text
import <name>@<major>.<minor>.<patch>.<build>/<entry>.bend as Lib
import 0x<32-hex-character-package-id>/<entry>.bend as Lib
```

Versions contain exactly four nonnegative decimal numbers; a three-part version,
range, `latest` tag or leading-zero component is not accepted by this pin's named
import grammar. Use the registry's exact entry path. Module filenames contain
plain names: `math.bend` is valid; `math.extra.bend` is not. Aliases belong to the
importing file; aliases that resolve to the same canonical module share its names.

## Understand resolution and the cache

The loader resolves an exact named version through `/name/<name>@<version>` and
caches that mapping. A hash import fetches the package manifest and its files
on a cache miss. The package identifier is the first 32 hexadecimal digits of
the manifest's SHA-256, prefixed with `0x`; the manifest lists file hashes and
paths. The loader checks fetched content against those hashes before writing it.
Integrity identifies content; it does not establish availability, provenance,
license suitability, proof soundness or runtime behavior.

`BEND_LIB` selects the library cache, defaulting to `~/.bend/lib`. Set it before
starting Bend. Use a new, task-owned directory for an honest cold-cache test:

```sh
# app.bend must already name a reviewed, pinned dependency.
package_cache_dir="$(mktemp -d)"
BEND_LIB="$package_cache_dir" bend app.bend --check-only
BEND_LIB="$package_cache_dir" bend PROOF.bend
BEND_LIB="$package_cache_dir" bend app.bend -o app.js
node app.js
```

These commands describe the intended validation sequence; a successful cold-cache
run has not been established here. Reuse that same directory for a warm-cache
check and record which path ran. The resolver does not rehash an already-present
cached source file on every load, and a cached name mapping avoids another name
lookup. Treat writable caches as trusted inputs; a warm-cache pass alone is not
evidence of a fresh registry fetch or current registry availability.

The downloaded `manifest` is an internal content inventory. The pinned CLI and
resolver do not provide a project dependency manifest/lockfile workflow. Do not
invent `bend install`, version-range resolution, a `bend.toml`, or a `bend.lock`.
Keep reviewed exact imports and provenance in the project instead. `BEND_LIB`
does not relocate the separate BendTT/Lean toolchain or resolve its setup failures.

## Keep dependency claims inside the proof boundary

Read the dependency's laws and any supplied proof modules. If a claim is open,
import the actual proof or discharge the actual obligation; do not replace the
claim with an assumption. Run the complete wrapper `PROOF.bend`, importing its
unchanged `LAWS.bend`, and require the ordinary passing verdict.

Check a targeted implementation mutation in a temporary copy. It should remain
well-typed while its unchanged law fails. State exactly what the law quantifies
over, and separately assert runtime success, malformed input, boundaries and
integration between dependencies. Correct decoding of a few examples is not a
universal roundtrip proof. A proof of a pure result does not certify external IO.

Imported unsafe definitions, user foreign effects and unfinished proofs can
prevent the loaded book from passing the proof gate. Report those dependencies;
do not hide them to claim verification. Distinguish ordinary checking, independent
kernel verification, concrete JS/native behavior and external-service behavior.
See [proofs](proofs.md) for the existing kernel and trust-boundary limits.

## Recognize publication commands

`bend file.bend --publish` uploads content publicly and permanently. The optional
`name@version` form names it; `bend link name@version 0x…` registers a name for an
already-published package. `bend link` is a registry mutation, not a local
development symlink. Neither command is part of installing or checking a package.
Treat publishing, naming and account setup as separate explicitly authorized work.
