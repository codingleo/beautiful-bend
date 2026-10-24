import Base

# Preserve order and emit two adjacent copies of each reading.
def duplicate(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      h <> h <> duplicate(t)
