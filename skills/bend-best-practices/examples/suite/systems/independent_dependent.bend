import Base
import ./workloads.bend as Work

def independent(+x: U32, +y: U32) -> U32 & Bool:
  a b = Work.square(x) Work.square(y)
  +result = (a + b : U32)
  (result, U32.is_eq(result, (Work.square(x) + Work.square(y) : U32)))

def dependent(x: U32, y: U32) -> U32:
  sum = (x + y : U32)
  Work.square(sum)

def main() -> (U32 & Bool) & U32:
  (independent(6, 7), dependent(6, 7))
