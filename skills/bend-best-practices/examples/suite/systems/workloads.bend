import Base

type Tree is Data:
  Empty{}
  Leaf{value: U32}
  Branch{left: Tree, right: Tree}

def checksum(tree: Tree) -> U32:
  match tree:
    case Empty{}:
      0
    case Leaf{value}:
      value
    case Branch{left, right}:
      a b = checksum(left) checksum(right)
      ((a * 31 : U32) + b : U32)

def checksum_seq(tree: Tree) -> U32:
  match tree:
    case Empty{}:
      0
    case Leaf{value}:
      value
    case Branch{left, right}:
      ((checksum_seq(left) * 31 : U32) + checksum_seq(right) : U32)

def total(tree: Tree) -> U32:
  match tree:
    case Empty{}:
      0
    case Leaf{value}:
      value
    case Branch{left, right}:
      a b = total(left) total(right)
      (a + b : U32)

def total_seq(tree: Tree) -> U32:
  match tree:
    case Empty{}:
      0
    case Leaf{value}:
      value
    case Branch{left, right}:
      (total_seq(left) + total_seq(right) : U32)

def leaves(tree: Tree) -> U32:
  match tree:
    case Empty{}:
      0
    case Leaf{value}:
      1
    case Branch{left, right}:
      a b = leaves(left) leaves(right)
      (a + b : U32)

def square(+value: U32) -> U32:
  (value * value : U32)
