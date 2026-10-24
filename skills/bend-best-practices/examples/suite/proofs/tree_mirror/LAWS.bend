import Base
import ./model.bend as Model

# Contract: Mirroring a binary tree twice restores its entire structure.
law involution:
  for tree: Model.Tree
  {Model.mirror(Model.mirror(tree)) == tree : Model.Tree}
