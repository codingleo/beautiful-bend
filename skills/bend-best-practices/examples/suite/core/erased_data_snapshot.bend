import Base

type Status is Data:
  Versioned{version: U32}

def snapshot(-A: Data, +value: A) -> A & A:
  (value, value)

def main() -> (U32 & U32) & (Status & Status) & (Bool & Bool):
  (snapshot(U32, 0), snapshot(Status, Versioned{7}), snapshot(Bool, True{}))
