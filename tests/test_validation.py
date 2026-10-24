"""Guard against a broken test tool being mistaken for a language rejection."""

import importlib.util
import json
from pathlib import Path
import subprocess
from unittest import mock
import unittest

spec = importlib.util.spec_from_file_location("validate", Path(__file__).resolve().parents[1] / "scripts/validate.py")
validate = importlib.util.module_from_spec(spec)
spec.loader.exec_module(validate)


class ResultIntegrity(unittest.TestCase):
    def result(self, code, out="", err=""):
        return subprocess.CompletedProcess(["bend"], code, out, err)

    def test_crash_is_not_expected_rejection(self):
        with self.assertRaises(ValueError):
            validate.assess(self.result(127, err="bend: not found"), diagnostic="consumed more than once")

    def test_unrelated_compiler_error_is_not_expected_rejection(self):
        with self.assertRaises(ValueError):
            validate.assess(self.result(1, err="SOME PROOFS FAIL\nfile not found"), diagnostic="consumed more than once")

    def test_runtime_output_is_exact(self):
        with self.assertRaises(ValueError):
            validate.assess(self.result(0, "42\nextra output\n"), stdout="42\n")

    def test_successful_exit_is_not_a_proof_verdict(self):
        with self.assertRaises(ValueError):
            validate.assess(self.result(0, "42\n"), verdict=True)

    def test_conflicting_verdict_is_rejected(self):
        with self.assertRaises(ValueError):
            validate.assess(self.result(0, "ALL PROOFS CHECK\n", "SOME PROOFS FAIL\n"), verdict=True)

    def test_expected_compiler_rejection_is_accepted(self):
        validate.assess(self.result(1, err="SOME PROOFS FAIL\nf (consumed more than once)"),
                        diagnostic="consumed more than once")

    def test_timeout_is_recorded_and_fails(self):
        report = {"checks": []}
        runner = validate.Runner(report)
        with mock.patch.object(validate.subprocess, "run", side_effect=subprocess.TimeoutExpired("bend", 60)):
            self.assertFalse(runner.run("slow fixture", ["bend", "slow.bend"]))
        self.assertEqual(report["checks"][0]["status"], "failed")
        self.assertIn("timed out", report["checks"][0]["error"])

    def test_missing_compiler_is_recorded_and_fails(self):
        report = {"checks": []}
        with mock.patch.object(validate.subprocess, "run", side_effect=FileNotFoundError("bend not found")):
            self.assertFalse(validate.Runner(report).run("missing", ["bend"]))
        self.assertEqual(len(report["checks"]), 1)


class ManifestIntegrity(unittest.TestCase):
    def setUp(self):
        self.manifest = json.loads((validate.ROOT / "tests/cases.json").read_text())

    def test_dropped_case_cannot_leave_suite_green(self):
        self.manifest["cases"].pop()
        with self.assertRaisesRegex(ValueError, "exactly"):
            validate.validate_manifest(self.manifest)

    def test_counting_same_source_twice_is_rejected(self):
        self.manifest["cases"][1]["file"] = self.manifest["cases"][0]["file"]
        with self.assertRaisesRegex(ValueError, "distinct files"):
            validate.validate_manifest(self.manifest)

    def test_missing_behavioral_oracle_is_rejected(self):
        self.manifest["cases"][0]["oracle"] = ""
        with self.assertRaisesRegex(ValueError, "missing oracle"):
            validate.validate_manifest(self.manifest)

    def test_changed_law_digest_is_rejected(self):
        proof = next(c for c in self.manifest["cases"] if c["kind"] == "proof")
        proof["law_sha256"] = "0" * 64
        with self.assertRaisesRegex(ValueError, "law specification changed"):
            validate.validate_manifest(self.manifest)

    def test_missing_proof_mutation_is_rejected(self):
        mutations = validate.read_json(validate.ROOT / 'tests/proof-mutations.json')
        mutations['mutations'].pop()
        with self.assertRaisesRegex(ValueError, '15 distinct'):
            validate.validate_mutations(mutations, self.manifest['cases'])

    def test_mutation_cannot_edit_laws(self):
        mutations = validate.read_json(validate.ROOT / 'tests/proof-mutations.json')
        mutations['mutations'][0]['file'] = self.manifest['cases'][0]['law_file']
        with self.assertRaisesRegex(ValueError, 'preserve LAWS'):
            validate.validate_mutations(mutations, self.manifest['cases'])

    def test_stale_mutation_target_is_rejected(self):
        mutations = validate.read_json(validate.ROOT / 'tests/proof-mutations.json')
        mutations['mutations'][0]['old'] = 'no such target'
        with self.assertRaisesRegex(ValueError, 'unique'):
            validate.validate_mutations(mutations, self.manifest['cases'])


if __name__ == "__main__":
    unittest.main()
