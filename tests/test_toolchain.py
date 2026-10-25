"""A dependency update must not silently disagree with the executable pins."""

import json
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
import setup_toolchain


class LockedToolchain(unittest.TestCase):
    def setUp(self):
        self.pin = json.loads((ROOT / 'toolchain.json').read_text())
        self.package = json.loads((ROOT / 'tooling/package.json').read_text())
        self.lock = json.loads((ROOT / 'tooling/package-lock.json').read_text())

    def test_checked_in_lock_agrees_with_source_runner_pin(self):
        setup_toolchain.check_lock(self.pin, self.package, self.lock)

    def test_dependabot_update_requires_matching_toolchain_pin(self):
        self.package['dependencies']['bun'] = '99.0.0'
        with self.assertRaisesRegex(ValueError, 'dependency and toolchain pin differ'):
            setup_toolchain.check_lock(self.pin, self.package, self.lock)

    def test_stale_lock_cannot_install_a_different_bun(self):
        self.lock['packages']['node_modules/bun']['version'] = '99.0.0'
        with self.assertRaisesRegex(ValueError, 'lockfile and toolchain pin differ'):
            setup_toolchain.check_lock(self.pin, self.package, self.lock)

    def test_tooling_cannot_accidentally_become_publishable(self):
        self.package['private'] = False
        with self.assertRaisesRegex(ValueError, 'private npm package'):
            setup_toolchain.check_lock(self.pin, self.package, self.lock)


if __name__ == '__main__':
    unittest.main()
