import Base
import ./model.bend as Model

# Contract: Incrementing every list entry preserves its length.
law length_preserved:
  for xs: List<&2, Nat>
  {List.length(&2, Nat, Model.increment_all(xs)) == List.length(&2, Nat, xs) : Nat}
