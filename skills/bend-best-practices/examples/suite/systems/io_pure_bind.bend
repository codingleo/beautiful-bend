import Base

def add_fee(value: U32) -> IO(U32):
  IO.pure(U32, (value + 7 : U32))

def report(value: U32) -> IO(Unit):
  IO.print(U32.show(value))

def main() -> IO(Unit):
  IO.bind(U32, Unit,
    IO.bind(U32, U32, IO.pure(U32, 35), add_fee), report)
