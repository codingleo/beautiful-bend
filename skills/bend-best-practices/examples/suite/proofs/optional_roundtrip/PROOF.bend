import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.roundtrip(value):
  match value:
    case None{}:
      {==}
    case Some{n}:
      {==}
