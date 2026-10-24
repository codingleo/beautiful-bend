import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.involution(tree):
  match tree:
    case Model.Leaf{value}:
      {==}
    case Model.Branch{left, right}:
      %Laws.involution(left) : {Model.Branch{Model.mirror(Model.mirror(left)), Model.mirror(Model.mirror(right))} == Model.Branch{_, right} : Model.Tree}
      %Laws.involution(right) : {Model.Branch{Model.mirror(Model.mirror(left)), Model.mirror(Model.mirror(right))} == Model.Branch{Model.mirror(Model.mirror(left)), _} : Model.Tree}
      {==}
