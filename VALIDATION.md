# Validation record — OSS readiness, 2026-10-25

The Bend source target remains **2.0.39**, revision
`295e996574573e3a88827b1cf7045b437333c8f0`. No corpus implementation, LAWS,
PROOF, independent oracle or existing mutation was changed in this patch.
The [100-case coverage](COVERAGE.md) and
[previous detailed findings](validation/2026-10-24-suite.md) remain applicable.

## Observed local results

| Layer | Result and exact scope |
|---|---|
| Structure | Local links, metadata, generated coverage, 100-case accounting and all law hashes passed |
| Validator tests | 23 passed: original 15 plus 4 Node policy/report tests and 4 tooling lock/pin tests |
| Ordinary checker/runtime suite | 100/100 cases and 320/320 command expectations passed |
| Independent BendTT kernel | 15/15 proof projects, covering their 19 stated law declarations, accepted; 18/18 command expectations met |
| Direct kernel controls | Valid reflexivity accepted; changing `.Off == .Off` to `.Off == .On` rejected with exit 1 and the expected unequal-label diagnostic |
| Configuration review | Workflow, issue forms and Dependabot YAML parsed; full-SHA action pins, always-upload conditions and 14-day retention checked |

Environment: Linux x86_64 cloud workspace, Python 3.12.14, Node v24.19.0,
Bun 1.4.4, Lean 4.34.0. A clean owned directory was prepared with the committed
npm lockfile and exact Bend commit. Lean's official Linux release archive was
SHA256-checked before extraction; BendTT was built from that same source pin.
The setup and kernel reports record tool versions and kernel/source digests.
The committed [compact observation record](validation/2026-10-25-oss.json) retains
command totals, case outcomes, kernel controls and report hashes; full local reports are in `.validation/`.

The kernel's 18 commands are **one Bend version read, two direct kernel controls,
and 15 `--verdict` calls**. They are separate from the 100 cases and 320 ordinary
command expectations. No native, GPU or runtime command is counted as a kernel
proof. A false proof rejected by the ordinary checker does not establish kernel
rejection; that is why the additional direct kernel control exists.

The 320-command suite's accounting remains: 2 version reads, 75 positive checks,
15 plain proof gates, 53 normalizations, 60 JS emissions, 60 Node runs, 25 expected
rejections, 13 standalone-valid mutant checks, 15 fixed-law mutation rejections,
and 2 extra proof-integrity rejections. The mutations and integrity checks are
outside the 100-case total. See the historical record for each law's limits.

## What improved and what the evidence means

Previously Node was read but its supported major was not enforced. The runner
now rejects wrong majors, prereleases and malformed version output. An integration
test injects a successful-exit Node 22 stub, checks that execution stops before
cases run, and asserts that a failed JSON report exists. Tooling tests reject
Bun manifest/lock/pin drift and an accidentally publishable tooling package.

The earlier default `--verdict` path failed while trying to create
`/home/agent/.bend` on a read-only filesystem, with Lean unavailable. This run
uses the upstream-supported **`BENDTT` prebuilt executable option**, building with
the pinned Lean release entirely in a task-owned directory. No home directory,
access restriction, credential or security setting was changed. The old failed
attempt remains in the dated record; it was not relabeled a pass.

Kernel acceptance supports the **19 written laws**, not whole implementations.
Map length does not prove payload correctness; involution does not uniquely
specify a toggle or mirror. Runtime assertions establish the listed finite
samples. Bend's translation into BendTT is itself not proven; neither the ordinary
checker nor this result proves compiler/backend correctness, dependency/IO safety,
or broad assistant effectiveness. Read the bundled [proof boundaries](skills/bend-best-practices/references/proofs.md).

## Reproduce and inspect CI

Use [the contributor setup commands](CONTRIBUTING.md#set-up-and-propose-a-change).
Both setup modes refuse to reset nonempty directories. A cold setup needs network
access; network/download/setup failures fail the job rather than becoming skips.
The Lean download is about 580 MB, and its fixed SHA256 must match. No website
installer or global package install is part of this workflow.

CI jobs are named **`check`** (the full ordinary suite) and **`BendTT kernel`**
(the separate proof suite, after `check`). Both use read-only repository permission,
full-SHA actions and no persisted checkout credentials. Actions were reviewed at
[checkout v7.0.1](https://github.com/actions/checkout/releases/tag/v7.0.1),
[setup-node v7.1.0](https://github.com/actions/setup-node/releases/tag/v7.1.0) and
[upload-artifact v7.0.2](https://github.com/actions/upload-artifact/releases/tag/v7.0.2).
Node 24 patches may advance; the actual version is recorded. Bend, Bun and Lean
remain pinned. See [compatibility](COMPATIBILITY.md).

Each job attempts to upload its named JSON reports even after failure when files
exist, with explicit **14-day retention**. Setup failures have their own report;
no report is promised if checkout never ran or the runner was terminated. A skipped
kernel job is not verification. Artifacts may require GitHub authentication and
expire; retain dated summaries for release evidence. The exact published-head CI
result will be linked in the PR handback after observation, not inferred locally.

## Host smoke and untested layers

- Codex **0.163.0**: `--version`, `--help`, `plugin --help` and `app-server --help`
  ran. Local JSON-RPC schema generation succeeded. A temporary project containing
  the complete skill was supplied to an app-server `skills/list` smoke attempt.
  It exited 1 before any discovery response: `failed to initialize sqlite state
  runtime under /run/codex-environment/codex-home`. The CLI also reported read-only
  PATH-alias setup. No permissions, persistent configuration or credentials were
  changed and the attempt was not retried. **Host discovery/activation remains
  untested**, as does automatic triggering. No paid/model call ran.
- Claude Code is not installed; its plugin validation/loading was not run.
- Native CPU/clang execution, GPU scheduling, CUDA/Metal, performance, macOS,
  Windows and external network/filesystem/process effects remain untested.
- The official Bend website installer previously returned HTTP 403; it was not
  retried or executed. No blocked BendHub work is included in this branch.
- Existing fresh-agent evaluations are historical; none was repeated for this
  repository/tooling patch. The global personal skill was not updated.

Owner decisions are listed in [the settings checklist](docs/MAINTAINER_CHECKLIST.md):
required checks, an achievable independent review policy, narrowly justified
bypass actors, and a verified private security reporting route. No settings,
merge, tag, release or package publication is part of this patch.
