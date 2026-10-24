import Base

def upper_bound(too_high: Bool, value: F32) -> F32:
  match too_high:
    case True{}:
      1.0
    case False{}:
      value

def lower_bound(too_low: Bool, +value: F32) -> F32:
  match too_low:
    case True{}:
      0.0
    case False{}:
      upper_bound((value > 1.0 : F32), value)

def percent(+value: F32) -> U32:
  F32.to_u32((lower_bound((value < 0.0 : F32), value) * 100.0 : F32))

def main() -> U32 & U32 & U32 & U32 & U32:
  (percent(F32.neg(0.5)), percent(0.0), percent(0.25), percent(1.0), percent(1.5))
