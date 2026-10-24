import Base

def stock_after(read: Array<U32> & U32) -> List<U32>:
  match read:
    case (cells, count):
      cells[2] <- (count + 3 : U32)
      Array.to_list(~U32, cells)

def withdraw(read: Array<U32> & U32) -> List<U32>:
  match read:
    case (cells, count):
      cells[1] <- (count - 2 : U32)
      stock_after(cells[2])

def main() -> List<U32>:
  cells = [5 : U32*4n]
  withdraw(cells[1])
