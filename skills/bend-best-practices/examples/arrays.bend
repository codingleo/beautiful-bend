import Base

# A computed pair is passed to a helper before matching it.
def finish(read: Array<U32> & U32, first: U32) -> U32 & U32:
  match read:
    case (cells, wrapped):
      (first, wrapped)

def read_again(read: Array<U32> & U32) -> U32 & U32:
  match read:
    case (cells, first):
      # Bend wraps indices: 8 addresses slot 0 in an eight-slot array.
      finish(cells[8], first)

def main() -> U32 & U32:
  cells = [0 : U32*8n]
  cells[0] <- 17
  read_again(cells[0])
