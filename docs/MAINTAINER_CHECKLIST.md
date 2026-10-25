# Maintainer settings checklist

This is an owner action list, not an assertion that these settings are enabled.
No settings, credentials, visibility, tags or releases are changed by this patch.

## Merge rules and reviews

- Confirm main requires pull requests and select the actual successful GitHub
  Actions check **`check`** from the **Validate skill** workflow as a required
  check. Keep its name stable; inspect a completed run when configuring it.
- Review whether **`BendTT kernel`** should also be required after its pinned setup
  and supported proof scope have been validated. It is distinct from `check`;
  ordinary checker success cannot substitute for it. A skipped job is not proof
  evidence. Decide how infrastructure outages should block changes explicitly.
- Align required code-owner review with [CODEOWNERS](../.github/CODEOWNERS).
  The current owner is `@codingleo`; choose an independent review path for that
  maintainer's own PRs before enforcing approvals that cannot be satisfied.
- Inspect all bypass actors and modes: broad administrator/maintainer roles,
  apps, deploy keys and organization-wide actors. Retain only justified,
  accountable exceptions; do not use a broad bypass to avoid missing reviews.
- Decide whether approvals must be refreshed after new commits and whether the
  branch must be up to date. Recheck the exact PR head before merging.

## Reporting and automation

- Enable private vulnerability reporting or publish a verified private contact,
  then update [SECURITY.md](../SECURITY.md). No private email or enabled reporting
  feature is assumed today.
- Review the [Dependabot configuration](../.github/dependabot.yml). It proposes
  weekly action updates and monthly tooling updates with low open-PR limits;
  it neither auto-merges nor updates Bend/Lean pins by itself.
- Keep workflow permissions read-only and PR execution on isolated hosted runners.
  Preserve full-SHA action pins and review upstream release notes/changes.
- Confirm report retention is acceptable: these workflows request **14 days**
  and upload only named JSON reports, including failed runs when reports exist.
  Artifacts expire and may require GitHub authentication to download. Keep a
  dated committed validation summary for long-lived release evidence.

## Before release

Follow [RELEASING.md](RELEASING.md), including an explicit publication decision.
A successful CI run does not authorize a settings change, merge, tag or release.
