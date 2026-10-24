import Base

def remaining_stock(stock: Nat, requested: Nat) -> Nat:
  (stock - requested : Nat)

def sequence_successor(sequence: U32) -> U32:
  (sequence + 1 : U32)

def main() -> Nat & Nat & Nat & U32 & U32:
  (remaining_stock(0n, 1n), remaining_stock(3n, 5n), remaining_stock(5n, 3n), (0 - 1 : U32), sequence_successor(4294967295))
