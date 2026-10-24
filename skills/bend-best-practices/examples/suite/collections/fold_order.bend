import Base

def nest(item: String, rest: String) -> String:
  "(" ++ item ++ ":" ++ rest ++ ")"

def route(acc: String, item: String) -> String:
  acc ++ "/" ++ item

def nested(items: List<&2, String>) -> String:
  List.foldr(~&2, ~String, ~String, ~nest, items, "z")

def path(items: List<&2, String>) -> String:
  List.foldl(~&2, ~String, ~String, ~route, items, "root")

def main() -> String:
  nested(["a", "b"]) ++ "|" ++ path(["a", "b"]) ++ "|" ++ nested([]) ++ "|" ++ path([])
