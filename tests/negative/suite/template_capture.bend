import Base

# Rejection rule: Template arguments must be closed syntax, without free caller locals.
def apply(~f: Nat -> Nat, n: Nat) -> Nat:
  f(n)

def bad(offset: Nat) -> Nat:
  apply(~(n => Nat.add(offset, n)), 0n)
