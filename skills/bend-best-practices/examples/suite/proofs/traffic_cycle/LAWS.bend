import Base
import ./model.bend as Model

# Contract: Three transitions restore each traffic signal phase.
law cycle:
  for phase: Model.Phase
  {Model.next(Model.next(Model.next(phase))) == phase : Model.Phase}
