import Base

# Rejection rule: Data fields must themselves be reusable Data; runtime closures have kind Type.
type CallbackBox is Data:
  Callback{run: Nat -> Nat}
