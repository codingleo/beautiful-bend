import Base

type State is Data:
  Idle{}
  Running{}
  Finished{}

def step(state: State) -> State:
  match state:
    case Idle{}:
      Running{}
    case Running{}:
      Finished{}
    case Finished{}:
      Finished{}

def reset(state: State) -> State:
  match state:
    case Idle{}:
      Idle{}
    case Running{}:
      Idle{}
    case Finished{}:
      Idle{}
