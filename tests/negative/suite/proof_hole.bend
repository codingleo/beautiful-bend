import Base

# Rejection rule: A named goal is an unfinished proof and cannot satisfy the law.
law identity:
  for n: Nat
  {Nat.add(n, 0n) == n : Nat}

def identity(n):
  ?unfinished_induction
