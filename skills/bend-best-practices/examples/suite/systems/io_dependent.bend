import Base
import ./workloads.bend as Work

def main() -> IO(Unit):
  do IO<Unit>:
    first : Chan(U32) <- IO.fork(U32, IO.pure(U32, (6 + 7 : U32)))
    sum : U32 <- IO.join(U32, first)
    second : Chan(U32) <- IO.fork(U32, IO.pure(U32, Work.square(sum)))
    value : U32 <- IO.join(U32, second)
    IO.print(U32.show(value))
    IO.print(U32.show(Work.square((6 + 7 : U32))))
