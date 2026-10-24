import Base
import ./workloads.bend as Work

def main() -> U32 & (U32 & Bool):
  +tree : Work.Tree = Work.Branch{Work.Empty{}, Work.Empty{}}
  (Work.total(tree), (Work.leaves(tree),
    U32.is_eq(Work.checksum(tree), Work.checksum_seq(tree))))
