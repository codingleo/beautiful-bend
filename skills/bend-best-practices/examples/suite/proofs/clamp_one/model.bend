import Base

def clamp(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+rest:
      1n
