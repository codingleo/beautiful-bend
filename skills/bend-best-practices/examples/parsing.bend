import Base

# Keep failure as None; zero is a valid parsed value.
def parsed_sum(left: String, right: String) -> Maybe<&2, U32>:
  do Maybe<&2, U32>:
    x : U32 <- U32.read(left)
    y : U32 <- U32.read(right)
    return (x + y : U32)

def describe(result: Maybe<&2, U32>) -> String:
  match result:
    case None{}:
      "invalid number"
    case Some{value}:
      U32.show(value)

def main() -> String & String & String:
  (describe(parsed_sum("12", "30")), describe(parsed_sum("oops", "30")), describe(parsed_sum("0", "0")))
