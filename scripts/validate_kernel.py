#!/usr/bin/env python3
"""Verify all 15 proof projects with an explicitly supplied pinned BendTT binary.

This is separate from the 100-case checker/JS suite. Two direct kernel controls
prove the kernel accepts reflexivity and rejects an unequal-label proof; ordinary
Bend rejection alone cannot establish that the independent kernel was reached.
"""

import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import sys
import tempfile

from validate import ROOT, Runner, digest, read_json, require, structure


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--bend', required=True)
    parser.add_argument('--kernel', type=Path, required=True)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    kernel = args.kernel.resolve()
    report = {'status': 'failed', 'scope': 'kernel-15', 'started_utc': datetime.now(timezone.utc).isoformat(),
              'expected_toolchain': read_json(ROOT / 'toolchain.json'), 'checks': [], 'cases': [],
              'skipped': ['Runtime, native/GPU behavior and performance; not kernel claims']}
    runner = Runner(report, env={'BENDTT': str(kernel), 'LEAN_STACK_SIZE_KB': '4194304'}, timeout=120)
    try:
        cases = [case for case in structure() if case['kind'] == 'proof']
        require(len(cases) == 15, 'Kernel scope must cover every proof project')
        require(kernel.is_file(), 'Kernel executable is missing')
        report.update(kernel=str(kernel), kernel_sha256=digest(kernel))
        version = report['expected_toolchain']['bend_version']
        require(runner.run('Bend version', [args.bend, 'version'], stdout=f'bend {version}\n'),
                'Wrong Bend toolchain')
        control = ROOT / 'tests/kernel/reflexivity.bendtt'
        require(runner.run('direct kernel: valid reflexivity', [str(kernel), str(control)],
                           stdout='ALL PROOFS CHECK\n'), 'Kernel positive control failed')
        with tempfile.TemporaryDirectory(prefix='beautiful-bend-kernel-') as directory:
            false = Path(directory) / 'false.bendtt'
            source = control.read_text()
            require(source.count('.Off == .Off') == 1, 'Kernel mutation target changed')
            false.write_text(source.replace('.Off == .Off', '.Off == .On'))
            require(runner.run('direct kernel: reject unequal labels', [str(kernel), str(false)],
                               diagnostic='expected: .Off\nobserved: .On'), 'Kernel negative control failed')
        ok = True
        for case in cases:
            passed = runner.run(case['id'] + ' kernel verdict',
                                [args.bend, str(ROOT / case['file']), '--verdict'], verdict=True)
            report['cases'].append({'id': case['id'], 'file': case['file'],
                                    'sha256': digest(ROOT / case['file']),
                                    'law_sha256': digest(ROOT / case['law_file']),
                                    'status': 'passed' if passed else 'failed'})
            print(f'{"PASS" if passed else "FAIL"} {case["id"]} BendTT verdict', flush=True)
            ok = passed and ok
        require(ok, 'One or more independent kernel checks failed')
        report['status'] = 'passed'
    except (ValueError, OSError, KeyError) as error:
        report['error'] = str(error)
        print('FAIL ' + str(error), file=sys.stderr)
    finally:
        report['command_count'] = len(report['checks'])
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2) + '\n')
    print(f'{report["status"].upper()}: {len(report["cases"])} proof projects, '
          f'{report["command_count"]} commands; scope=kernel-15')
    return 0 if report['status'] == 'passed' else 1


if __name__ == '__main__':
    sys.exit(main())
