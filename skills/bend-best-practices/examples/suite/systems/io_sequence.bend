import Base

def main() -> IO(Unit):
  do IO<Unit>:
    IO.write("begin:")
    IO.print("loaded")
    IO.print("validated")
    IO.write("commit:")
    IO.print("done")
