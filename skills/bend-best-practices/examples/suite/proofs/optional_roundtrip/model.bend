import Base

type Outcome is Data:
  Missing{}
  Found{value: Nat}

def encode(value: Maybe<&2, Nat>) -> Outcome:
  match value:
    case None{}:
      Missing{}
    case Some{n}:
      Found{n}

def decode(value: Outcome) -> Maybe<&2, Nat>:
  match value:
    case Missing{}:
      None{}
    case Found{n}:
      Some{n}
