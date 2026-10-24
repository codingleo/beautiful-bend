import Base

def twice(f: U32 -> U32, value: U32) -> U32:
  f(f(value))

def main() -> U32:
  twice(x => (x + 1 : U32), 40)
