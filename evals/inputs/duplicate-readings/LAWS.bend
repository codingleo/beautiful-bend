import Base
import ./model.bend as Model

# Specification: duplicate each reading; exactly twice as many positions.
def twice(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+rest:
      2n+twice(rest)

law size:
  for xs: List<&2, Nat>
  {List.length(&2, Nat, Model.duplicate(xs)) == twice(List.length(&2, Nat, xs)) : Nat}
