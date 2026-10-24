import Base

def capacity(read: Array<U32> & U32) -> U32:
  match read:
    case (cells, n):
      n

def main() -> U32 & (U32 & U32):
  (capacity(Array.size(U32, Array.new(U32, 0n, 9))),
    (capacity(Array.size(U32, [0 : U32*8n])),
      capacity(Array.size(U32, [0 : U32^4n]))))
