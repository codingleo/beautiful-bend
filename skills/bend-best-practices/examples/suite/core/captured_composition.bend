import Base

def add_offset(offset: U32) -> U32 -> U32:
  value => (value + offset : U32)

def scale(factor: U32) -> U32 -> U32:
  value => (value * factor : U32)

def compose(first: U32 -> U32, second: U32 -> U32, value: U32) -> U32:
  second(first(value))

def main() -> U32 & U32 & U32 & U32:
  plus_seven = U32.add(7)
  (compose(add_offset(3), scale(2), 0), compose(add_offset(3), scale(2), 4), compose(scale(2), add_offset(3), 4), plus_seven(5))
