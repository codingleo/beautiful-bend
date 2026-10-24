import Base
import ./model.bend as Model

# Contract: Reset after any bounded workflow step establishes the idle state.
law reset_after_step:
  for state: Model.State
  {Model.reset(Model.step(state)) == Model.Idle{} : Model.State}

law done_absorbs:
  {Model.step(Model.Finished{}) == Model.Finished{} : Model.State}
