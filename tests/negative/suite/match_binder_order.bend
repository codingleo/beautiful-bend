import Base

# Matching a later binder then returning to an earlier binder violates structural order.
def wrong(first: Bool, second: Bool) -> Bool:
  match second:
    case False{}:
      match first:
        case False{}:
          False{}
        case True{}:
          True{}
    case True{}:
      first
