import Base
import ./model.bend as Model

# Contract: Every Nat has a successor whose predecessor recovers the original value.
law successor_exists:
  for n: Nat
  exs next: Nat
  {Model.pred(next) == n : Nat}
