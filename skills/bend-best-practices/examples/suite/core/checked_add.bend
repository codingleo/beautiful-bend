import Base

type Checked is Data:
  Fits{value: U32}
  Overflow{}

def finish_add(fits: Bool, left: U32, right: U32) -> Checked:
  match fits:
    case True{}:
      Fits{(left + right : U32)}
    case False{}:
      Overflow{}

def checked_add(+left: U32, +right: U32) -> Checked:
  finish_add((right <= (4294967295 - left : U32) : U32), left, right)

def main() -> Checked & Checked & Checked & Checked & Checked:
  (checked_add(0, 0), checked_add(4294967295, 0), checked_add(4294967294, 1), checked_add(4294967295, 1), checked_add(2147483648, 2147483648))
