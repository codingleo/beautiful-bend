import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.reset_after_step(state):
  match state:
    case Model.Idle{}:
      {==}
    case Model.Running{}:
      {==}
    case Model.Finished{}:
      {==}

def Laws.done_absorbs():
  {==}
