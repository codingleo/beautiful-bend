import Base

def copies(pair: Array<U32> & Array<U32>) -> List<U32> & List<U32>:
  match pair:
    case (left, right):
      left[0] <- 99
      right[1] <- 73
      (Array.to_list(~U32, left), Array.to_list(~U32, right))

def main() -> List<U32> & List<U32>:
  copies(Array.clone(U32, [7 : U32*4n]))
