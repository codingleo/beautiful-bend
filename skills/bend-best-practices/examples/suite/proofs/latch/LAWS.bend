import Base
import ./model.bend as Model

# Contract: Setting a latch is idempotent and always establishes True.
law idempotent:
  for state: Bool
  {Model.set(Model.set(state)) == Model.set(state) : Bool}

law established:
  for state: Bool
  {Model.set(state) == True{} : Bool}
