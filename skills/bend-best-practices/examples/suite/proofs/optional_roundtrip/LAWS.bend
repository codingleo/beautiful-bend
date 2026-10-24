import Base
import ./model.bend as Model

# Contract: Encoding optional Nat into a domain outcome and decoding preserves absence and payload.
law roundtrip:
  for value: Maybe<&2, Nat>
  {Model.decode(Model.encode(value)) == value : Maybe<&2, Nat>}
