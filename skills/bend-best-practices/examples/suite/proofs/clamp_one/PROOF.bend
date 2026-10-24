import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.idempotent(n):
  match n:
    case 0n:
      {==}
    case 1n+rest:
      {==}

def Laws.zero_preserved():
  {==}
