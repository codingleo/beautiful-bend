import Base
import ./workloads.bend as Work

def main() -> U32 & Bool:
  +tree : Work.Tree = Work.Branch{Work.Branch{Work.Leaf{1}, Work.Leaf{2}},
    Work.Branch{Work.Leaf{3}, Work.Leaf{4}}}
  (Work.checksum(tree), U32.is_eq(Work.checksum(tree), Work.checksum_seq(tree)))
