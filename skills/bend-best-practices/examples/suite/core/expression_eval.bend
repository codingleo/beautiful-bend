import Base

type Expression is Data:
  Literal{value: U32}
  Add{left: Expression, right: Expression}
  Multiply{left: Expression, right: Expression}

def evaluate(expression: Expression) -> U32:
  match expression:
    case Literal{value}:
      value
    case Add{left, right}:
      (evaluate(left) + evaluate(right) : U32)
    case Multiply{left, right}:
      (evaluate(left) * evaluate(right) : U32)

def main() -> U32 & U32 & U32 & U32:
  (evaluate(Literal{0}), evaluate(Add{Literal{4}, Literal{5}}), evaluate(Multiply{Add{Literal{2}, Literal{3}}, Literal{4}}), evaluate(Add{Literal{2}, Multiply{Literal{3}, Literal{4}}}))
