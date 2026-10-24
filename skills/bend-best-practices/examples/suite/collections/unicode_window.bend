import Base

def first_code(s: String) -> U32:
  Maybe.default(&2, U32, Maybe.map(&2, Char, U32, Char.to_u32, String.get(s, 0n)), 0)

def window(s: String, start: Nat, count: Nat) -> String:
  String.reverse(String.take(String.drop(s, start), count))

def round_trip(+s: String) -> Bool:
  String.eq(s, String.from_list(String.to_list(s)))

def main() -> Nat & Nat & U32 & U32 & Nat & Bool:
  (String.length("Aé🙂Z"), String.length(window("Aé🙂Z", 1n, 2n)), first_code(window("Aé🙂Z", 1n, 2n)), first_code(window("", 0n, 2n)), String.length("é"), round_trip("Aé🙂Z"))
