import Base

# Rejection rule: An erased binder is unavailable to runtime computation.
def reveal(-secret: Nat) -> Nat:
  secret
