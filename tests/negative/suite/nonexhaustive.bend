import Base

# Rejection rule: A total safe definition must cover every constructor of the scrutinee.
def missing(flag: Bool) -> Nat:
  match flag:
    case True{}:
      1n
