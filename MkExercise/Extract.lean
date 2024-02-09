import Lake

open Lake DSL System

/-- String with an indent -/
structure Code where
  /-- the size of indent. in other words, the number of leading whitespace. -/
  indent : Nat
  /-- the content of the code. -/
  body : String

def String.toCode (line : String) : Code :=
  let count := line.takeWhile (fun c => c == ' ') |> String.length
  let line := line.trim
  { indent := count, body := line }

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
    let ⟨count, trimedLine⟩ := line.toCode

    if trimedLine.startsWith "-- sorry" then
      listen := ! listen
      if ! listen then
        content := content.pushn ' ' count ++ "sorry\n"
      continue

    if listen then
      if let some index := findWhere line "/- sorry -/" then
        content := content ++ line.take index ++ "sorry\n"
      else
        content := content ++ line ++ "\n"
      continue
  return content
