import Base
import ./model.bend as Model

# Contract: Equal counts yield equal successor ticket numbers.
law ticket_congruence:
  for a: Nat
  for b: Nat
  for same: {a == b : Nat}
  {Model.ticket(a) == Model.ticket(b) : Nat}
