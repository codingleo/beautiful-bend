import Base

# Rejection rule: The successor branch must prove successor equals zero, which distinct Nat constructors refute.
law collapse:
  for n: Nat
  {n == 0n : Nat}

def collapse(n):
  match n:
    case 0n:
      {==}
    case 1n+rest:
      %Equal.sym(Nat, rest, 0n, collapse(rest)) : {1n+_ == 0n : Nat}
      {==}
