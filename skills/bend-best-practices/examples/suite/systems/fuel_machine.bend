import Base

type Progress is Data:
  Complete{ticks: U32}
  Paused{remaining: Nat, ticks: U32}

def advance(fuel: Nat, remaining: Nat, ticks: U32) -> Progress:
  match fuel remaining:
    case _ 0n:
      Complete{ticks}
    case 0n 1n+rest:
      Paused{1n+rest, ticks}
    case 1n+more 1n+rest:
      advance(more, rest, (ticks + 1 : U32))

def main() -> Progress & (Progress & Progress):
  (advance(0n, 0n, 0), (advance(2n, 3n, 0), advance(3n, 3n, 0)))
