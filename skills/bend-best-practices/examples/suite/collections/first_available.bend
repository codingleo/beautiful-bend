import Base

def enough(x: U32) -> Bool:
  (x >= 3 : U32)

def remainder(x: U32) -> String:
  U32.show((x - 3 : U32))

def reserve(counts: List<&2, U32>) -> String:
  Maybe.default(&2, String, Maybe.map(&2, U32, String, remainder, List.find(~U32, ~enough, counts)), "unavailable")

def main() -> String:
  reserve([0, 2, 5, 8]) ++ "|" ++ reserve([3]) ++ "|" ++ reserve([0, 2]) ++ "|" ++ reserve([])
