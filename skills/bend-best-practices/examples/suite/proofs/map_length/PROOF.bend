import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.length_preserved(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Laws.length_preserved(t) : {1n+List.length(&2, Nat, Model.increment_all(t)) == 1n+_ : Nat}
      {==}
