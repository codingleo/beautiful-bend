import Base

type Tree is Type:
  Leaf{value: U32}
  Branch{left: Tree, right: Tree}

def total(tree: Tree) -> U32:
  match tree:
    case Leaf{value}:
      value
    case Branch{left, right}:
      a b = total(left) total(right)
      (a + b : U32)

# This fixture is balanced. The type itself does not enforce balance.
# It checks results, not speedup. JS executes the parallel calls sequentially.
def main() -> U32:
  total(Branch{Branch{Leaf{1}, Leaf{2}}, Branch{Leaf{3}, Leaf{4}}})
