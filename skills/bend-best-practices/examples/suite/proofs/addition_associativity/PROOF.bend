import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.associative(a, b, c):
  match a:
    case 0n:
      {==}
    case 1n+rest:
      %Laws.associative(rest, b, c) : {1n+Model.add(Model.add(rest, b), c) == 1n+_ : Nat}
      {==}
