import Base
import ./counter.bend as Counter

# The specification: keep these claims fixed while implementing the proof.
law zero_steps:
  for balance: Nat
  {Counter.credit(0n, balance) == balance : Nat}

law empty_balance:
  for steps: Nat
  {Counter.credit(steps, 0n) == steps : Nat}
