import Base

# Inputs are small enough that the U32 sum of squares does not overflow.
def square(+x: U32) -> U32:
  (x * x : U32)

def energy(readings: List<U32>) -> U32:
  List.foldl(~&1, ~U32, ~U32, ~U32.add, List.map(~U32, ~U32, ~(x => square(x)), readings), 0)

def main() -> U32 & U32 & U32:
  (energy([]), energy([0]), energy([3, 4, 0]))
