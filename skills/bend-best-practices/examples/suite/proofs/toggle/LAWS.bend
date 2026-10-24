import Base
import ./model.bend as Model

# Contract: Toggling twice restores every Boolean state.
law involution:
  for state: Bool
  {Model.toggle(Model.toggle(state)) == state : Bool}
