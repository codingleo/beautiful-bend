import Base

# Rejection rule: The first member references an unfilled later member; safe structural recursion does not permit this cycle.
def even(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+rest:
      odd(rest)

def odd(n: Nat) -> Bool:
  match n:
    case 0n:
      False{}
    case 1n+rest:
      even(rest)
