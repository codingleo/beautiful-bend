import Base
import ./counter.bend as Counter
import ./LAWS.bend as Laws

def Laws.zero_steps(balance):
  {==}

def Laws.empty_balance(steps):
  match steps:
    case 0n:
      {==}
    case 1n+rest:
      %Laws.empty_balance(rest) : {1n+Counter.credit(rest, 0n) == 1n+_ : Nat}
      {==}
