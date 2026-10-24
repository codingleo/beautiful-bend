import Base

def clean(items: List<&2, String>) -> List<&2, String>:
  match items:
    case Nil{}:
      []
    case h <> t:
      String.to_lower(String.trim(h)) <> clean(t)

def nonempty(s: String) -> Bool:
  Bool.not(String.is_empty(s))

def labels(s: String) -> String:
  String.join(List.filter(~String, ~nonempty, clean(String.split(s, ','))), "/")

def main() -> String:
  labels(" Red ,, BLUE , ") ++ "|" ++ labels("") ++ "|" ++ labels(",,") ++ "|" ++ labels(" two words , GREEN")
