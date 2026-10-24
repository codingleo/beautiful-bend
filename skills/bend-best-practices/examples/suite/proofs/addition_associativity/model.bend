import Base

def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+rest:
      1n+add(rest, b)
