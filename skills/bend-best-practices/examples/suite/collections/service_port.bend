import Base

import ./decimal.bend as D

def in_range(ok: Bool, value: U32) -> Result<&2, &2, String, U32>:
  match ok:
    case False{}:
      Fail{"range"}
    case True{}:
      Done{value}

def validate(+value: U32) -> Result<&2, &2, String, U32>:
  in_range((value >= 1 : U32) && (value <= 65535 : U32), value)

def port(text: String) -> Result<&2, &2, String, U32>:
  do Result<&2, &2, String, U32>:
    value : U32 <- D.number(text, "syntax")
    validate(value)

def main() -> String:
  D.describe(port("443")) ++ "|" ++ D.describe(port("65535")) ++ "|" ++ D.describe(port("0")) ++ "|" ++ D.describe(port("65536")) ++ "|" ++ D.describe(port("")) ++ "|" ++ D.describe(port("x"))
