import Base

def passing(x: U32) -> Bool:
  (x >= 60 : U32)

def leaders(scores: List<&2, U32>, limit: Nat) -> List<&2, U32>:
  List.take(&2, U32, List.sort(~U32, ~U32.is_ge, List.filter(~U32, ~passing, scores)), limit)

def main() -> List<&2, U32> & List<&2, U32> & List<&2, U32> & List<&2, U32>:
  (leaders([80, 59, 60, 99, 80], 3n), leaders([], 3n), leaders([0, 59], 3n), leaders([100], 0n))
