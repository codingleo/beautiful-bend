import Base
import ./model.bend as Model

# Contract: Saturating a Nat count at one is idempotent and preserves zero.
law idempotent:
  for n: Nat
  {Model.clamp(Model.clamp(n)) == Model.clamp(n) : Nat}

law zero_preserved:
  {Model.clamp(0n) == 0n : Nat}
