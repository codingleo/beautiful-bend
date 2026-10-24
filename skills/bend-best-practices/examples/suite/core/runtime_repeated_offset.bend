import Base

def accrue(periods: Nat, +offset: U32, total: U32) -> U32:
  match periods:
    case 0n:
      total
    case 1n+remaining:
      accrue(remaining, offset, (total + offset : U32))

def main() -> U32 & U32 & U32 & U32:
  (accrue(0n, 7, 3), accrue(1n, 7, 3), accrue(4n, 7, 3), accrue(6n, 0, 9))
