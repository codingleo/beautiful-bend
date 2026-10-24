import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.size(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Laws.size(t) : {2n+List.length(&2, Nat, Model.duplicate(t)) == 2n+_ : Nat}
      {==}
