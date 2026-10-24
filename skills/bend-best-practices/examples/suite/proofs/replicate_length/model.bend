import Base

def batch(n: Nat) -> List<&2, Unit>:
  match n:
    case 0n:
      Nil{}
    case 1n+rest:
      Unit{} <> batch(rest)
