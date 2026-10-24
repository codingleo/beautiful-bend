import Base

def lookup(read: Map<&2, U32> & U32) -> String:
  match read:
    case (config, value):
      U32.show(value)

def overlay() -> Map<&2, U32>:
  base = Map.from_list(&2, U32, [("port", 80), ("retries", 2), ("legacy", 1)])
  updates = Map.from_list(&2, U32, [("port", 443), ("timeout", 5)])
  Map.del(&2, U32, Map.union(&2, U32, base, updates), "legacy")

def main() -> String:
  +config = overlay()
  +empty = Map.del(&2, U32, Map.new(&2, U32), "missing")
  lookup(Map.get(U32, 99, config, "port")) ++ "/" ++ lookup(Map.get(U32, 99, config, "retries")) ++ "/" ++ lookup(Map.get(U32, 99, config, "timeout")) ++ "/" ++ lookup(Map.get(U32, 99, config, "legacy")) ++ "/" ++ Nat.show(Map.size(&2, U32, config)) ++ "|" ++ lookup(Map.get(U32, 99, empty, "port")) ++ "/" ++ Nat.show(Map.size(&2, U32, empty))
