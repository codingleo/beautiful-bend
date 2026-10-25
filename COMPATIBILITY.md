# Compatibility and evidence

Plugin metadata is currently **0.2.0**. The plugin version and Bend compiler
version are independent. No tagged release or host certification is implied by
that metadata. See [toolchain.json](toolchain.json) for authoritative compiler pins
and [VALIDATION.md](VALIDATION.md) for dated observations.

| Component/layer | Supported validation target and limits |
|---|---|
| Language | Bend 2.0.39, source `295e996574573e3a88827b1cf7045b437333c8f0`; not the older HVM-based generation |
| Source runner | Bun 1.4.4 with npm integrity hashes in `tooling/package-lock.json` |
| JavaScript | Stable Node 24.x; the runner rejects other majors and prereleases. Patch versions may advance and are recorded in reports |
| Python | Python 3.12 for the setup/validation scripts; no Python third-party packages required |
| Kernel | Lean 4.34.0 release archive SHA256-pinned in `toolchain.json`; BendTT built from the same Bend source pin. Automated setup is Linux x86_64 only |
| Ordinary validation | 100 cases: 60 runtime programs, 15 proof projects, 25 expected rejections; extra mutation/harness checks are separate |
| Kernel validation | 15 proof projects / 19 stated laws, plus direct valid/invalid kernel controls; separate report and CI job |
| Native CPU / GPU | Not exercised by this repository's validation jobs; no performance or scheduling evidence |
| Codex / Claude hosts | Standalone file/link structure and prior explicit agent use checked. Host automatic discovery/loading is not certified; see the dated smoke record |
| Other platforms | macOS, Windows, CUDA/Metal, network effects and custom foreign runtime behavior untested |

The lockfile makes npm dependency resolution reproducible; it does not freeze the
OS or guarantee bit-identical binaries. Network access is required for a cold
source/toolchain setup. Updating Bend, Bun or Lean requires an explicit pin review
and rerun, including rejection/mutation checks. A new Node 24 security patch is
allowed by the major-version policy; CI reports the actual installed version.
