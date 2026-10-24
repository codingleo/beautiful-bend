import Base
import ./model.bend as Model

# Contract: Appending an empty suffix preserves all list elements.
law right_identity:
  for xs: List<&2, Nat>
  {Model.append(xs, Nil{}) == xs : List<&2, Nat>}
