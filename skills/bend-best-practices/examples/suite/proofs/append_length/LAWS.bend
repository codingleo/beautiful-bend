import Base
import ./model.bend as Model

# Contract: Concatenation adds list lengths.
law length_sum:
  for xs: List<&2, Nat>
  for ys: List<&2, Nat>
  {List.length(&2, Nat, Model.append(xs, ys)) == Nat.add(List.length(&2, Nat, xs), List.length(&2, Nat, ys)) : Nat}
