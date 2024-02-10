import Lake

open Lake DSL System

/-- new notaion to represent `x := x ++ e`. -/
syntax ident "++=" term : doElem

macro_rules
  | `(doElem| $x:ident ++= $e:term) => `(doElem| ($x) := ($x) ++ ($e))

/-- determines whether the string contains the given string and returns its index -/
def findWhere (line : String) (tgt : String) : Option Nat := Id.run do
  for i in [0 : line.length - tgt.length + 1] do
    let rest := line.drop i
    if rest.startsWith tgt then
      return some i
  return none

/-- remove some content from the given content
and replace it with `sorry` -/
def extractExercise (lines : List String) : String := Id.run do
  let mut listen := true
  let mut content := ""
  for line in lines do
    if line.endsWith "--#" then
      continue

    if let some index := findWhere line "-- sorry" then
      listen := ! listen
      if ! listen then
        content ++= line.take index ++ "sorry\n"
      continue

    if listen then
      if let some index := findWhere line "/- sorry -/" then
        content ++= line.take index ++ "sorry\n"
      else
        content ++= line ++ "\n"
      continue

  if ! listen then
    panic! "Unexpected file ending. This file contains unclosed `-- sorry`."

  return content
