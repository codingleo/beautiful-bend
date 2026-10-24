import Base
import ./model.bend as Model
import ./LAWS.bend as Laws

def Laws.ticket_congruence(a, b, same):
  Equal.cong(Nat, Nat, Model.ticket, a, b, same)
