import Base
import ./workloads.bend as Work

def main() -> IO(Unit):
  do IO<Unit>:
    left : Chan(U32) <- IO.fork(U32, IO.pure(U32, Work.square(6)))
    right : Chan(U32) <- IO.fork(U32, IO.pure(U32, Work.square(7)))
    b : U32 <- IO.join(U32, right)
    a : U32 <- IO.join(U32, left)
    IO.print(U32.show((a + b : U32)))
    IO.print(U32.show((Work.square(6) + Work.square(7) : U32)))
