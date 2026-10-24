import Base

# Incomplete implementation to repair: currently retains only one copy.
def duplicate(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> duplicate(t)
