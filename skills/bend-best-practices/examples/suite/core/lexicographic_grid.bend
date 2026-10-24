import Base

def count_cells(+rows: Nat, columns: Nat, +width: Nat, tally: U32) -> U32:
  match rows columns:
    case 0n _:
      tally
    case 1n+rest 0n:
      count_cells(rest, width, width, tally)
    case 1n+rest 1n+remaining:
      count_cells(rows, remaining, width, (tally + 1 : U32))

def main() -> U32 & U32 & U32 & U32 & U32:
  (count_cells(0n, 3n, 3n, 0), count_cells(2n, 0n, 0n, 0), count_cells(1n, 1n, 1n, 0), count_cells(2n, 3n, 3n, 0), count_cells(3n, 2n, 2n, 4))
