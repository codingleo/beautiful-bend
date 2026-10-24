import Base

def swap(-A: Type, -B: Type, pair: A & B) -> B & A:
  match pair:
    case (left, right):
      (right, left)

def identity(-A: Type, value: A) -> A:
  value

def add_offset(offset: U32) -> U32 -> U32:
  value => (value + offset : U32)

def main() -> (Nat & U32) & (U32 & Bool) & U32:
  operation = identity(U32 -> U32, add_offset(5))
  (swap(U32, Nat, (7, 3n)), swap(Bool, U32, (False{}, 0)), operation(7))
