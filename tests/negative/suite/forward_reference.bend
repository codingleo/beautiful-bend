import Base

# Rejection rule: Safe live code cannot depend on a not-yet-filled definition.
def first(n: Nat) -> Nat:
  later(n)

def later(n: Nat) -> Nat:
  n
