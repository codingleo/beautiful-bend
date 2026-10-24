import Base

def pred(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+rest:
      rest
