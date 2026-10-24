import Base

type Gate is Data:
  Closed{}
  Opened{}

type GateEvent is Data:
  Coin{}
  Push{}

def step(gate: Gate, event: GateEvent) -> Gate:
  match gate event:
    case Closed{} Coin{}:
      Opened{}
    case Closed{} Push{}:
      Closed{}
    case Opened{} Coin{}:
      Opened{}
    case Opened{} Push{}:
      Closed{}

def main() -> Gate & Gate & Gate & Gate & Gate:
  (step(Closed{}, Coin{}), step(Closed{}, Push{}), step(Opened{}, Coin{}), step(Opened{}, Push{}), step(step(step(Closed{}, Coin{}), Push{}), Push{}))
