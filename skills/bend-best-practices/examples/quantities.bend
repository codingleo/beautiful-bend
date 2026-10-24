import Base

# Only this numeric input needs duplication.
def square(+value: U32) -> U32:
  (value * value : U32)

def increment(value: U32) -> U32:
  (value + 1 : U32)

# List.map receives a closed template, not a reusable runtime closure.
def increments(values: List<U32>) -> List<U32>:
  List.map(~U32, ~U32, ~increment, values)

def main() -> U32 & List<U32>:
  (square(7), increments([0, 9, 41]))
