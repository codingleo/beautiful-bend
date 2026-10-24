import Base

def increment_read(read: Map<&2, U32> & U32, key: String) -> Map<&2, U32>:
  match read:
    case (counts, count):
      Map.set(&2, U32, counts, key, (count + 1 : U32))

def increment(counts: Map<&2, U32>, +key: String) -> Map<&2, U32>:
  increment_read(Map.get(U32, 0, counts, key), key)

def count(words: List<&2, String>) -> Map<&2, U32>:
  List.foldl(~&2, ~String, ~Map<&2, U32>, ~(counts => key => increment(counts, key)), words, Map.new(&2, U32))

def value(read: Map<&2, U32> & U32) -> String:
  match read:
    case (counts, found):
      U32.show(found)

def summary(+counts: Map<&2, U32>) -> String:
  value(Map.get(U32, 0, counts, "red")) ++ "/" ++ Nat.show(Map.size(&2, U32, counts))

def main() -> String:
  +counts = count(["red", "blue", "red"])
  value(Map.get(U32, 0, counts, "red")) ++ "/" ++ value(Map.get(U32, 0, counts, "blue")) ++ "/" ++ value(Map.get(U32, 0, counts, "absent")) ++ "/" ++ Nat.show(Map.size(&2, U32, counts)) ++ "|" ++ summary(count([])) ++ "|" ++ summary(count(["Red", "red"]))
