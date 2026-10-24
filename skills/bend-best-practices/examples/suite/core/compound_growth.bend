import Base

def grow(periods: Nat, principal: U32) -> U32:
  match periods:
    case 0n:
      principal
    case 1n+remaining:
      grow(remaining, (principal * 2 : U32))

def main() -> U32 & U32 & U32 & U32:
  (grow(0n, 5), grow(1n, 5), grow(3n, 5), grow(5n, 0))
