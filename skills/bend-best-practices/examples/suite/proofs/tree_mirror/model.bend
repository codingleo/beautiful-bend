import Base

type Tree is Data:
  Leaf{value: Nat}
  Branch{left: Tree, right: Tree}

def mirror(tree: Tree) -> Tree:
  match tree:
    case Leaf{value}:
      Leaf{value}
    case Branch{left, right}:
      Branch{mirror(right), mirror(left)}
