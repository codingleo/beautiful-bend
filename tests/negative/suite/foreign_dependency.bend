import Base

# Rejection rule: The ordinary proof gate refuses user foreign assumptions even when their declared signature is well typed.
def external() -> IO(Nat):
  import "./foreign_dependency.js"

def answer() -> IO(Nat):
  external()
