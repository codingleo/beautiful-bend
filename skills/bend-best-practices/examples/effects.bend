import Base
import ./parsing.bend as Parse

def main() -> IO(Unit):
  do IO<Unit>:
    message : String = Parse.describe(Parse.parsed_sum("12", "30"))
    IO.print(message)
    IO.print(Parse.describe(Parse.parsed_sum("oops", "30")))
