#!/usr/bin/env python3
"""Prepare the pinned source runner, optionally BendTT, in a new owned directory.

No Bend website installer, home-directory changes, global packages or credentials.
Network/setup failures fail closed and are recorded when --report is supplied.
"""

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import shlex
import shutil
import subprocess
import sys

from validate import ROOT, assess, read_json, require


def check_lock(pin, package, lock):
    version = pin['bun_version']
    require(package.get('private') is True, 'Tooling must remain a private npm package')
    require(package['dependencies']['bun'] == version, 'Bun dependency and toolchain pin differ')
    require(lock['lockfileVersion'] == 3 and
            lock['packages']['']['dependencies']['bun'] == version and
            lock['packages']['node_modules/bun']['version'] == version,
            'Bun lockfile and toolchain pin differ; regenerate the lockfile')


def sha256(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--directory', type=Path, required=True, help='New or empty task-owned directory')
    parser.add_argument('--kernel', action='store_true', help='Also build the pinned Linux x86_64 BendTT kernel')
    parser.add_argument('--lean-archive', type=Path, help='Use an existing archive only if its pinned SHA256 matches')
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    report = {'status': 'failed', 'started_utc': datetime.now(timezone.utc).isoformat(), 'commands': []}

    def run(command, cwd=None, timeout=600):
        command = [str(part) for part in command]
        print('$ ' + shlex.join(command), flush=True)
        entry = {'command': command}
        report['commands'].append(entry)
        result = subprocess.run(command, cwd=cwd, capture_output=True, text=True, timeout=timeout,
                                env={**os.environ, 'BEND_NO_TELEMETRY': '1'})
        entry.update(exit=result.returncode, stdout=result.stdout, stderr=result.stderr)
        require(result.returncode == 0, result.stdout + result.stderr)
        return result

    try:
        pin = read_json(ROOT / 'toolchain.json')
        report['toolchain'] = pin
        check_lock(pin, read_json(ROOT / 'tooling/package.json'), read_json(ROOT / 'tooling/package-lock.json'))
        assess(run(['node', '--version']), node_major=pin['node_major'])
        require(not args.lean_archive or args.kernel, '--lean-archive requires --kernel')
        require(not args.directory.is_symlink(), 'Setup directory must not be a symlink')
        dest = args.directory.resolve()
        require(not dest.exists() or (dest.is_dir() and not any(dest.iterdir())),
                'Setup directory must be new or empty; existing work is never reset')
        dest.mkdir(parents=True, exist_ok=True)
        source, npm_dir, bin_dir = dest / 'bend', dest / 'npm', dest / 'bin'
        npm_dir.mkdir(); bin_dir.mkdir()
        for name in ('package.json', 'package-lock.json'):
            shutil.copyfile(ROOT / 'tooling' / name, npm_dir / name)
        run(['npm', 'ci', '--prefix', npm_dir, '--cache', dest / 'npm-cache', '--no-audit', '--no-fund'])
        bun = npm_dir / 'node_modules/.bin/bun'
        require(run([bun, '--version']).stdout.strip() == pin['bun_version'], 'Installed Bun version differs')
        run(['git', 'init', '--quiet', source])
        run(['git', '-C', source, 'remote', 'add', 'origin', pin['bend_repository']])
        run(['git', '-C', source, 'fetch', '--depth', '1', 'origin', pin['bend_commit']])
        run(['git', '-C', source, 'checkout', '--detach', 'FETCH_HEAD'])
        require(run(['git', '-C', source, 'rev-parse', 'HEAD']).stdout.strip() == pin['bend_commit'],
                'Fetched Bend revision differs')
        wrapper = bin_dir / 'bend'
        wrapper.write_text('#!/bin/sh\nexport BEND_NO_TELEMETRY=1\nexec ' +
                           shlex.join([str(bun), str(source / 'bend2/main.ts')]) + ' "$@"\n')
        wrapper.chmod(0o755)
        assess(run([wrapper, 'version']), stdout=f'bend {pin["bend_version"]}\n')
        report['bend'] = str(wrapper)
        if args.kernel:
            require(platform.system() == 'Linux' and platform.machine() in ('x86_64', 'AMD64'),
                    'Automated kernel setup currently supports Linux x86_64 only')
            lean_version = pin['lean_version_for_verdict']
            safe = (source / 'bend2/safe.ts').read_text()
            require(f'const LEAN_VERSION = "{lean_version}";' in safe, 'Lean pin disagrees with Bend')
            archive = args.lean_archive.resolve() if args.lean_archive else dest / 'lean.tar.zst'
            if not args.lean_archive:
                run(['curl', '--fail', '--location', '--silent', '--show-error', '--proto', '=https',
                     '--tlsv1.2', pin['lean_linux_x86_64']['url'], '--output', archive])
            require(sha256(archive) == pin['lean_linux_x86_64']['sha256'], 'Lean archive SHA256 mismatch')
            run(['tar', '--zstd', '-xf', archive, '-C', dest])
            lean_bin = dest / f'lean-{lean_version}-linux/bin'
            observed = run([lean_bin / 'lean', '--version']).stdout
            require(re.search(r'^Lean \(version ' + re.escape(lean_version) + r'[,\s)]', observed),
                    'Lean version differs from the pin')
            build = dest / 'kernel-build'; build.mkdir()
            kernel_source = source / 'bend2/bendtt.lean'
            shutil.copyfile(kernel_source, build / 'bendtt.lean')
            run([lean_bin / 'lean', '-c', 'bendtt.c', 'bendtt.lean'], cwd=build)
            kernel = bin_dir / 'bendtt'
            run([lean_bin / 'leanc', '-O3', '-DNDEBUG', 'bendtt.c', '-o', kernel], cwd=build)
            report.update(kernel=str(kernel), kernel_sha256=sha256(kernel),
                          kernel_source_sha256=sha256(kernel_source), lean=observed.strip())
        report['status'] = 'passed'
    except (OSError, ValueError, KeyError, subprocess.TimeoutExpired) as error:
        report['error'] = str(error)
        print('SETUP FAILED: ' + str(error), file=sys.stderr)
    finally:
        if args.report:
            args.report.parent.mkdir(parents=True, exist_ok=True)
            args.report.write_text(json.dumps(report, indent=2) + '\n')
    if report['status'] == 'passed':
        print('READY ' + report['bend'])
        if args.kernel:
            print('BENDTT=' + report['kernel'])
    return 0 if report['status'] == 'passed' else 1


if __name__ == '__main__':
    sys.exit(main())
