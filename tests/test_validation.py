"""Guard against a broken test tool being mistaken for a language rejection."""

import importlib.util
from pathlib import Path
import subprocess
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


if __name__ == "__main__":
    unittest.main()
