import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.length_sum(xs, ys):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Laws.length_sum(t, ys) : {1n+List.length(&2, Nat, Model.append(t, ys)) == 1n+_ : Nat}
      {==}
