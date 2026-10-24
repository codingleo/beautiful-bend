import Base

# Amounts are whole cents. Callers must keep arithmetic within U32 range.
type Line is Data:
  Charge{units: U32, unit_cents: U32}
  Complimentary{}

def line_cents(line: Line) -> U32:
  match line:
    case Charge{units, unit_cents}:
      (units * unit_cents : U32)
    case Complimentary{}:
      0

# The list shrinks before the accumulator changes.
def total_cents(lines: List<Line>, acc: U32) -> U32:
  match lines:
    case Nil{}:
      acc
    case Con{line, rest}:
      total_cents(rest, (acc + line_cents(line) : U32))

def main() -> U32 & U32:
  (total_cents([], 0), total_cents([Charge{2, 120}, Complimentary{}, Charge{3, 50}], 0))
