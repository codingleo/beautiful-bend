import Base

# Rejection rule: Erased fields remain unavailable to live computation after pattern matching.
type SecretBox is Data:
  Hidden{-secret: Nat}

def reveal(box: SecretBox) -> Nat:
  match box:
    case Hidden{secret}:
      secret
