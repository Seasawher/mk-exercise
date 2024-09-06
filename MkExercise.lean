import MkExercise.Cli

def main (args : List String) : IO UInt32 := do
  mkExerciseCmd.validate args
