import Base

# Whole nonempty ASCII decimal; no sign, spaces, separators or overflow.
def decimal_gate(ok: Bool, text: String) -> Maybe<&2, U32>:
  match ok:
    case False{}:
      None{}
    case True{}:
      U32.read(text)

def decimal(+text: String) -> Maybe<&2, U32>:
  decimal_gate(Bool.not(String.is_empty(text)) && List.all(~&2, ~Char, ~Char.is_digit, String.to_list(text)), text)

def require_number(value: Maybe<&2, U32>, error: String) -> Result<&2, &2, String, U32>:
  match value:
    case None{}:
      Fail{error}
    case Some{x}:
      Done{x}

def number(text: String, error: String) -> Result<&2, &2, String, U32>:
  require_number(decimal(text), error)

def describe(result: Result<&2, &2, String, U32>) -> String:
  match result:
    case Fail{error}:
      "error:" ++ error
    case Done{x}:
      U32.show(x)

def optional(value: Maybe<&2, U32>) -> String:
  match value:
    case None{}:
      "none"
    case Some{x}:
      U32.show(x)
