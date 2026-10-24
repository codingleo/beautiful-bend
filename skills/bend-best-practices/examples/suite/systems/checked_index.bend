import Base

def found(read: Array<U32> & U32) -> Maybe<&1, U32>:
  match read:
    case (cells, value):
      Some{value}

def checked(valid: Bool, cells: Array<U32>, index: U32) -> Maybe<&1, U32>:
  match valid:
    case False{}:
      None{}
    case True{}:
      found(cells[index])

def sized(read: Array<U32> & U32, +index: U32) -> Maybe<&1, U32>:
  match read:
    case (cells, capacity):
      checked(U32.is_lt(index, capacity), cells, index)

def get(cells: Array<U32>, index: U32) -> Maybe<&1, U32>:
  sized(Array.size(U32, cells), index)

def main() -> Maybe<&1, U32> & Maybe<&1, U32>:
  (get([8 : U32*4n], 3), get([8 : U32*4n], 4))
