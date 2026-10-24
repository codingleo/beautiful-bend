import Base

# Credit one unit per step, using Nat rather than wrapping machine arithmetic.
def credit(steps: Nat, balance: Nat) -> Nat:
  match steps:
    case 0n:
      balance
    case 1n+rest:
      1n+credit(rest, balance)
