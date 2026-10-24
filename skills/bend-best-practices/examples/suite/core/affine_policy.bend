import Base

type FeePolicy is Type:
  Fixed{amount: U32}
  Adjust{operation: U32 -> U32}

def charge(policy: FeePolicy, amount: U32) -> U32:
  match policy:
    case Fixed{fixed}:
      fixed
    case Adjust{operation}:
      operation(amount)

def add_fee(fee: U32) -> U32 -> U32:
  amount => (amount + fee : U32)

def multiplier(factor: U32) -> U32 -> U32:
  amount => (amount * factor : U32)

def main() -> U32 & U32 & U32 & U32:
  (charge(Fixed{5}, 99), charge(Adjust{add_fee(3)}, 0), charge(Adjust{add_fee(3)}, 7), charge(Adjust{multiplier(4)}, 3))
