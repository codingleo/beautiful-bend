# Security policy

Security-sensitive findings include a validation bypass, an unsafe dependency or
workflow, or guidance that conceals a failed proof or exposes private data.
Ordinary usage questions and non-sensitive bugs belong in [public issues](https://github.com/codingleo/beautiful-bend/issues).

## Reporting

1. Visit [the repository Security page](https://github.com/codingleo/beautiful-bend/security).
   If GitHub shows **Report a vulnerability**, use that private reporting flow.
2. If that option is absent, open a public issue titled **Security contact request**
   and ask [@codingleo](https://github.com/codingleo) for a private reporting route.
   Include only that a confidential channel is needed. Withhold exploit details,
   affected private systems, credentials and sensitive attachments until a private
   route is agreed.

**Owner setup still needed:** private vulnerability reporting has not been
confirmed enabled, and this repository publishes no verified private email.
The owner should enable GitHub private reporting or publish a verified private
contact and update this policy. This file does not enable that feature. See
[GitHub's reporting guidance](https://docs.github.com/code-security/security-advisories/guidance-on-reporting-and-writing/privately-reporting-a-security-vulnerability).

When a private route is available, provide the affected commit/version, minimal
reproducer, impact, expected/actual behavior and relevant redacted evidence.
Never include live credentials. Coordinate disclosure with the maintainer; no
response deadline or bounty is promised here.

## Scope and maintenance

The current target is documented in [COMPATIBILITY.md](COMPATIBILITY.md).
Fixes are reviewed against current main; there is no maintained historical/LTS
branch or promise of backports. A passing fixture or kernel verdict only supports
its stated claim, not the safety of all generated code, dependencies or host effects.
