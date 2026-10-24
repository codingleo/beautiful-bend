import Base

# Rejection rule: A local binding does not become a parameter or pattern field eligible for structural matching.
def wrong(flag: Bool) -> Bool:
  local = flag
  match local:
    case False{}:
      True{}
    case True{}:
      False{}
