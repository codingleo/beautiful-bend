import Base

type Phase is Data:
  Red{}
  Green{}
  Amber{}

def next(phase: Phase) -> Phase:
  match phase:
    case Red{}:
      Green{}
    case Green{}:
      Amber{}
    case Amber{}:
      Red{}
