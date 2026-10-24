import Base

def normalize(tags: List<&2, String>) -> List<&2, String>:
  match tags:
    case Nil{}:
      []
    case h <> t:
      String.to_lower(String.trim(h)) <> normalize(t)

def canonical(tags: List<&2, String>) -> String:
  unique = Set.del(Set.from_list(normalize(tags)), "")
  String.join(List.sort(~String, ~String.is_le, Set.to_list(unique)), ",")

def main() -> String:
  canonical([" Blue ", "red", "blue", ""]) ++ "|" ++ canonical([]) ++ "|" ++ canonical([" ", ""]) ++ "|" ++ canonical(["b", "A", "a"])
