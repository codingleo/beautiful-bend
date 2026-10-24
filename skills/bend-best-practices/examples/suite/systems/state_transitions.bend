import Base

type Command is Data:
  Add{units: U32}
  Take{units: U32}

type Stock is Data:
  Stock{units: U32, rejected: U32}

def decide(allowed: Bool, units: U32, rejected: U32, amount: U32) -> Stock:
  match allowed:
    case True{}:
      Stock{(units - amount : U32), rejected}
    case False{}:
      Stock{units, (rejected + 1 : U32)}

def apply(command: Command, state: Stock) -> Stock:
  match command state:
    case Add{amount} Stock{units, rejected}:
      Stock{(units + amount : U32), rejected}
    case Take{+amount} Stock{+units, rejected}:
      decide(U32.is_le(amount, units), units, rejected, amount)

def run(commands: List<Command>, state: Stock) -> Stock:
  match commands:
    case []:
      state
    case command <> rest:
      run(rest, apply(command, state))

def main() -> Stock & Stock:
  (run([], Stock{0, 0}),
    run([Add{5}, Take{5}, Take{1}, Add{3}, Take{2}], Stock{0, 0}))
