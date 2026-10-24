import Base

import ./decimal.bend as D

def divide(zero: Bool, numerator: U32, denominator: U32) -> Result<&2, &2, String, U32>:
  match zero:
    case True{}:
      Fail{"zero"}
    case False{}:
      Done{(numerator / denominator : U32)}

def ratio(left: String, right: String) -> Result<&2, &2, String, U32>:
  do Result<&2, &2, String, U32>:
    x : U32 <- D.number(left, "numerator")
    +y : U32 <- D.number(right, "denominator")
    divide(U32.is_eq(y, 0), x, y)

def main() -> String:
  D.describe(ratio("20", "6")) ++ "|" ++ D.describe(ratio("0", "7")) ++ "|" ++ D.describe(ratio("1", "0")) ++ "|" ++ D.describe(ratio("bad", "bad")) ++ "|" ++ D.describe(ratio("1", "bad"))
