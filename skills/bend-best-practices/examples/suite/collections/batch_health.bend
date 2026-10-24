import Base

def alarm(x: U32) -> Bool:
  (x > 90 : U32)

def valid(x: U32) -> Bool:
  (x <= 100 : U32)

def health(+readings: List<&2, U32>) -> String:
  Bool.show(List.any(~&2, ~U32, ~alarm, readings)) ++ "/" ++ Bool.show(List.all(~&2, ~U32, ~valid, readings))

def main() -> String:
  health([]) ++ "|" ++ health([0, 90]) ++ "|" ++ health([91, 100]) ++ "|" ++ health([101])
