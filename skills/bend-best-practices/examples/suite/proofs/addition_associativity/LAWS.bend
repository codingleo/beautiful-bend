import Base
import ./model.bend as Model

# Contract: Grouping unbounded Nat additions preserves the sum.
law associative:
  for a: Nat
  for b: Nat
  for c: Nat
  {Model.add(Model.add(a, b), c) == Model.add(a, Model.add(b, c)) : Nat}
