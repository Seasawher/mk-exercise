def main : IO UInt32 := do
  let firstActual ← IO.FS.readFile ⟨"Test/Out/Solution.lean"⟩
  let firstExpected ← IO.FS.readFile ⟨"Test/Exp/Solution.lean"⟩
  if firstActual != firstExpected then
    IO.eprintln "result is wrong"
    return 1
  return 0
