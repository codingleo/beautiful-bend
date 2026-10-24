import Base

# This is a matched-prefix quote; unmatched quantities/prices are excluded.
def add_line(total: U32, line: U32 & U32) -> U32:
  match line:
    case (units, price):
      (total + units * price : U32)

def quote(units: List<U32>, prices: List<U32>) -> U32:
  List.foldl(~&1, ~(U32 & U32), ~U32, ~add_line, List.zip(&1, U32, &1, U32, units, prices), 0)

def main() -> U32 & U32 & U32 & U32:
  (quote([2, 3], [10, 7, 99]), quote([], [5]), quote([5], []), quote([4, 9], [5]))
