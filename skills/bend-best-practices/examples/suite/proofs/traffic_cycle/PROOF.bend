import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.cycle(phase):
  match phase:
    case Model.Red{}:
      {==}
    case Model.Green{}:
      {==}
    case Model.Amber{}:
      {==}
