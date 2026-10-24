import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.idempotent(state):
  match state:
    case False{}:
      {==}
    case True{}:
      {==}

def Laws.established(state):
  match state:
    case False{}:
      {==}
    case True{}:
      {==}
