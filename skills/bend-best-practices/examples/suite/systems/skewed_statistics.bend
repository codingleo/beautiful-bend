import Base
import ./workloads.bend as Work

def main() -> U32 & (U32 & Bool):
  +tree : Work.Tree = Work.Branch{Work.Leaf{4}, Work.Branch{Work.Leaf{5},
    Work.Branch{Work.Empty{}, Work.Leaf{6}}}}
  (Work.total(tree), (Work.leaves(tree),
    U32.is_eq(Work.total(tree), Work.total_seq(tree))))
