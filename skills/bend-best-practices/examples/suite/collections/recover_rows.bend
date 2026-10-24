import Base

import ./decimal.bend as D

type Tally is Data:
  Tally{total: U32, rejected: U32}

def record(result: Result<&2, &2, String, U32>, tally: Tally) -> Tally:
  match result tally:
    case Fail{error} Tally{total, rejected}:
      Tally{total, (rejected + 1 : U32)}
    case Done{value} Tally{total, rejected}:
      Tally{(total + value : U32), rejected}

def accumulate(tally: Tally, row: String) -> Tally:
  record(D.number(row, "malformed"), tally)

def describe(tally: Tally) -> String:
  match tally:
    case Tally{total, rejected}:
      U32.show(total) ++ "/" ++ U32.show(rejected)

def recover(rows: List<&2, String>) -> String:
  describe(List.foldl(~&2, ~String, ~Tally, ~accumulate, rows, Tally{0, 0}))

def main() -> String:
  recover(["2", "x", "0", "3"]) ++ "|" ++ recover([]) ++ "|" ++ recover(["", "bad"]) ++ "|" ++ recover(["0"])
