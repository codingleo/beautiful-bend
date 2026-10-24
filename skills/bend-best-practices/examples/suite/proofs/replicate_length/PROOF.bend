import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.exact_length(n):
  match n:
    case 0n:
      {==}
    case 1n+rest:
      %Laws.exact_length(rest) : {1n+List.length(&2, Unit, Model.batch(rest)) == 1n+_ : Nat}
      {==}
