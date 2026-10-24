import Base

def sum(acc: U32, values: List<U32>) -> U32:
  match values:
    case Nil{}:
      acc
    case Con{head, tail}:
      sum((acc + head : U32), tail)
