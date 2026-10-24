import Base

def over_limit(value: U32) -> Bool:
  U32.is_lt(9, value)

def main() -> List<Bool>:
  cells = [0 : U32*4n]
  cells[1] <- 9
  cells[2] <- 10
  cells[3] <- 20
  Array.to_list(~Bool, Array.map(~U32, ~Bool, ~over_limit, cells))
