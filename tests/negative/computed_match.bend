import Base

def display(value: U32) -> String:
  match U32.is_eq(value, 0):
    case True{}:
      "zero"
    case False{}:
      "nonzero"
