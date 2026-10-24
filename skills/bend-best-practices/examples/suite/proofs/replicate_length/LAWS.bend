import Base
import ./model.bend as Model

# Contract: A batch of n identical units contains exactly n elements.
law exact_length:
  for n: Nat
  {List.length(&2, Unit, Model.batch(n)) == n : Nat}
