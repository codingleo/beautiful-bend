import Base

def finish(read: Array<String> & String, first: String) -> String & String:
  match read:
    case (cells, last):
      (first, last)

def read_first(read: Array<String> & String) -> String & String:
  match read:
    case (cells, first):
      finish(Array.get(String, cells, 3), first)

def main() -> String & String:
  cells = ["empty" : String*4n]
  filled = Array.set(String, cells, 3, "ready")
  read_first(Array.get(String, filled, 0))
