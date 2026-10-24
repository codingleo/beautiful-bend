import Base

def page(rows: List<U32>, offset: Nat, size: Nat) -> List<U32>:
  List.reverse(&1, U32, List.take(&1, U32, List.drop(&1, U32, rows, offset), size))

def main() -> List<U32> & List<U32> & List<U32> & List<U32> & List<U32>:
  (page([10, 20, 30, 40, 50], 2n, 2n), page([10, 20, 30, 40, 50], 4n, 3n), page([10], 2n, 3n), page([], 0n, 2n), page([10], 0n, 0n))
