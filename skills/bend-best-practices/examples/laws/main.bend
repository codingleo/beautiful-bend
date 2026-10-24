import Base
import ./counter.bend as Counter

def main() -> Nat & Nat:
  (Counter.credit(0n, 9n), Counter.credit(3n, 4n))
