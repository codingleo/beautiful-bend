import Base

type Checked is Data:
  Fits{value: U32}
  Overflow{}

def finish_multiply(fits: Bool, left: U32, right: U32) -> Checked:
  match fits:
    case True{}:
      Fits{(left * right : U32)}
    case False{}:
      Overflow{}

def nonzero_multiply(zero: Bool, +left: U32, +right: U32) -> Checked:
  match zero:
    case True{}:
      Fits{0}
    case False{}:
      finish_multiply((right <= (4294967295 / left : U32) : U32), left, right)

def checked_multiply(+left: U32, right: U32) -> Checked:
  nonzero_multiply(U32.is_eq(left, 0), left, right)

def main() -> Checked & Checked & Checked & Checked & Checked:
  (checked_multiply(0, 4294967295), checked_multiply(4294967295, 0), checked_multiply(1, 4294967295), checked_multiply(65535, 65537), checked_multiply(65536, 65536))
