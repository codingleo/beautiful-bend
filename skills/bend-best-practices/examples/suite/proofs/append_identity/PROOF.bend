import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.right_identity(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Laws.right_identity(t) : {h <> Model.append(t, Nil{}) == h <> _ : List<&2, Nat>}
      {==}
