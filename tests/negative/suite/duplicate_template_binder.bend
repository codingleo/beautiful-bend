import Base

# Rejection rule: Template binder names must be fresh, preventing substitution-key collisions.
def invalid(~T: Type, ~x: T, ~T: Type) -> T:
  x
