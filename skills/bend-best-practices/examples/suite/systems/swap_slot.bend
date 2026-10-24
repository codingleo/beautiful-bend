import Base

def finish(read: Array<String> & String, old: String) -> String & String:
  match read:
    case (cells, current):
      (old, current)

def swapped(read: Array<String> & String) -> String & String:
  match read:
    case (cells, old):
      finish(Array.get(String, cells, 1), old)

def main() -> String & String:
  swapped(Array.swap(String, ["queued" : String*2n], 1, "sent"))
