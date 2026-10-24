import Base

def twice(f: U32 -> U32, value: U32) -> U32:
  f(f(value))
