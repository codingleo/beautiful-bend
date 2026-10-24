import Base

# Rejection rule: Template parameters must precede ordinary parameters.
def bad(n: Nat, ~f: Nat -> Nat) -> Nat:
  f(n)
