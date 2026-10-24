import Base

type QuantitySummary is Type:
  Summary{total: U32, malformed: Nat}

# Keep parse failure distinct from Some{0}.
def add_parsed(parsed: Maybe<&2, U32>, summary: QuantitySummary) -> QuantitySummary:
  match parsed summary:
    case None{} Summary{total, malformed}:
      Summary{total, 1n+malformed}
    case Some{value} Summary{total, malformed}:
      Summary{(total + value : U32), malformed}

# The shrinking list precedes the changing accumulator.
def summarize_go(quantities: List<String>, summary: QuantitySummary) -> QuantitySummary:
  match quantities:
    case Nil{}:
      summary
    case Con{quantity, rest}:
      summarize_go(rest, add_parsed(U32.read(quantity), summary))

# Valid quantities and their sum are assumed to fit U32.
def summarize_quantities(quantities: List<String>) -> QuantitySummary:
  summarize_go(quantities, Summary{0, 0n})

def show_summary(summary: QuantitySummary) -> String:
  match summary:
    case Summary{total, malformed}:
      "total=" ++ U32.show(total) ++ ", malformed=" ++ Nat.show(malformed)

def main() -> IO(Unit):
  do IO<Unit>:
    IO.print("empty: " ++ show_summary(summarize_quantities([])))
    IO.print("mixed: " ++ show_summary(summarize_quantities(["12", "bad", "0", "7", ""])))
    IO.print("all-invalid: " ++ show_summary(summarize_quantities(["bad", "", "-1", "1.5", " 2", "3 "])))
    IO.print("zero: " ++ show_summary(summarize_quantities(["0"])))
    IO.print("upper-bound: " ++ show_summary(summarize_quantities(["4294967295", "0"])))
