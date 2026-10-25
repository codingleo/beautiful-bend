# Release and compatibility procedure

Releases are manual maintainer decisions. This repository does not auto-tag,
publish a plugin, upload release assets or publish to BendHub.

1. Choose a reviewed commit and describe its final behavior in [CHANGELOG.md](../CHANGELOG.md).
   Review [COMPATIBILITY.md](../COMPATIBILITY.md), compiler pins, licenses and
   bundled notices. Keep plugin metadata and documented versions consistent.
2. Use patch versions for compatible corrections/documentation and minor versions
   for added capabilities/examples or materially changed guidance while the
   plugin is 0.x. Explain any compatibility break explicitly; do not infer Bend
   compatibility from the plugin version number.
3. Run the documented contributor checks and inspect **both** `check` and
   `BendTT kernel` on the exact candidate head. Review failed/unsupported layers,
   original laws, independent oracles and mutation results. Do not weaken them
   for a release. Preserve a dated summary because CI artifacts expire after 14 days.
4. Test host loading when the relevant CLI/application is available. Structure
   checks do not certify host discovery, activation or usability. Record host
   versions and skips; never advertise native/GPU verification from JS results.
5. Inspect the complete installable skill directory: entry point, references,
   examples, metadata, license and notices must travel together. Confirm relative
   links/imports survive relocation. Review changes to any existing personal copy
   separately; a repository release does not update user installations.
6. Obtain the maintainer's explicit decision on the version, tag and distribution
   channel before performing publication. Record the resulting immutable commit
   and observed checks in release notes. No publication command is part of CI.

For a toolchain update, review primary documentation/source and update the Bend
revision, Bun manifest **and lockfile**, or Lean archive URL/digest together with
their corresponding pins. A Dependabot tooling PR that changes only Bun must
also reconcile `toolchain.json`; the setup check deliberately rejects drift.
Node 24.x patches are allowed and recorded. Move to another major only after
changing the compatibility policy and testing it explicitly.
