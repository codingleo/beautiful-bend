import Base
import ./model.bend as Model

def show_duplicate(xs: List<&2, Nat>) -> IO(Unit):
  IO.print(List.show(~&2, ~Nat, ~Nat.show, Model.duplicate(xs)))

def main() -> IO(Unit):
  do IO<Unit>:
    show_duplicate([])
    show_duplicate([0n])
    show_duplicate([1n])
    show_duplicate([3n, 1n, 2n])
    show_duplicate([5n, 5n, 0n])
    show_duplicate([255n, 256n, 257n])
