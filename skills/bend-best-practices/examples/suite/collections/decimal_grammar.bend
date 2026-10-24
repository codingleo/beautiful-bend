import Base

import ./decimal.bend as D

def parse(s: String) -> String:
  D.optional(D.decimal(s))

def main() -> String:
  parse("007") ++ "|" ++ parse("0") ++ "|" ++ parse("4294967295") ++ "|" ++ parse("") ++ "|" ++ parse("+1") ++ "|" ++ parse(" 1") ++ "|" ++ parse("12x") ++ "|" ++ parse("١") ++ "|" ++ parse("4294967296")
