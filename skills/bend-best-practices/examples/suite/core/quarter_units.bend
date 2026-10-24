import Base

def hundredths(quarters: Nat) -> U32:
  units = (U32.to_f32(U32.from_nat(quarters)) * 0.25 : F32)
  F32.to_u32((units * 100.0 : F32))

def round_trip(count: Nat) -> Nat:
  U32.to_nat(U32.from_nat(count))

def main() -> U32 & U32 & U32 & U32 & Nat & Nat:
  (hundredths(0n), hundredths(1n), hundredths(3n), hundredths(8n), round_trip(0n), round_trip(17n))
