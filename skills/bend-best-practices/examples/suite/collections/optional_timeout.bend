import Base

import ./decimal.bend as D

def bounded(ok: Bool, value: U32) -> Maybe<&2, U32>:
  match ok:
    case False{}:
      None{}
    case True{}:
      Some{value}

def seconds(+value: U32) -> Maybe<&2, U32>:
  bounded((value <= 4294967 : U32), value)

def parse(text: String) -> Maybe<&2, U32>:
  Maybe.bind(&2, U32, U32, D.decimal(text), x => seconds(x))

def milliseconds(value: U32) -> U32:
  (value * 1000 : U32)

def timeout(primary: String, fallback: String) -> U32:
  Maybe.default(&2, U32, Maybe.map(&2, U32, U32, milliseconds, Maybe.or(&2, U32, parse(primary), parse(fallback))), 1000)

def main() -> U32 & U32 & U32 & U32 & U32:
  (timeout("2", "9"), timeout("bad", "3"), timeout("0", "3"), timeout("", "bad"), timeout("4294968", "bad"))
