import Base

import ./decimal.bend as D

# This fixture uses bounded totals; production unbounded sums need checks or Nat.
def sum_rows(rows: List<&2, String>) -> Result<&2, &2, String, U32>:
  match rows:
    case Nil{}:
      Done{0}
    case +h <> t:
      do Result<&2, &2, String, U32>:
        x : U32 <- D.number(h, "token=" ++ h)
        rest : U32 <- sum_rows(t)
        return (x + rest : U32)

def main() -> String:
  D.describe(sum_rows(["2", "3", "0"])) ++ "|" ++ D.describe(sum_rows([])) ++ "|" ++ D.describe(sum_rows(["2", "x", "y"])) ++ "|" ++ D.describe(sum_rows([""]))
