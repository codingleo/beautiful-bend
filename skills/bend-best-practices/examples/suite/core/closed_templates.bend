import Base

def add_three(value: U32) -> U32:
  (value + 3 : U32)

def twice(~operation: U32 -> U32, value: U32) -> U32:
  operation(operation(value))

def main() -> U32 & U32 & U32 & U32:
  (twice(~add_three, 0), twice(~add_three, 4), twice(~(value => (value * 2 : U32)), 3), twice(~(value => value), 0))
