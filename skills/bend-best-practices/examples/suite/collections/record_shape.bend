import Base

# This tiny format has no quoting or escaping; commas always delimit fields.
def record(fields: List<&2, String>) -> String:
  match fields:
    case a <> b <> c <> Nil{}:
      a ++ "/" ++ b ++ "/" ++ c
    case _:
      "bad fields"

def parse(s: String) -> String:
  record(String.split(s, ','))

def main() -> String:
  parse("a,b,c") ++ "|" ++ parse("a,,c") ++ "|" ++ parse(",,") ++ "|" ++ parse("") ++ "|" ++ parse("a,b,") ++ "|" ++ parse("a,b,c,d")
