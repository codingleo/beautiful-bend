import Base

def increment_all(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      (1n+h) <> increment_all(t)
