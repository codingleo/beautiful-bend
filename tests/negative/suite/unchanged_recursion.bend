import Base

# Rejection rule: A safe self-call requires a smaller pattern-derived argument.
def forever(n: Nat) -> Nat:
  forever(n)
