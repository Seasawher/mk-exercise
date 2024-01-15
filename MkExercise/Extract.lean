import Lake

open Lake DSL System

/-- this function trim initial whitespace of given string
and also count how many whitespaces arise -/
def cutWhiteSpace (line : String) : Nat × String :=
  let count := line.takeWhile (fun c => c == ' ') |> String.length
  let line := line.trim
  (count, line)

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
    let ⟨count, trimedLine⟩ := cutWhiteSpace line

    if trimedLine.startsWith "-- sorry" then
      listen := ! listen
      if ! listen then
        content := content.pushn ' ' count ++ "sorry\n"
      continue

    if listen then
      let index := findWhere line "/- sorry -/"
      if let some index := index then
        content := content.pushn ' ' count ++ line.trim.take (index - count) ++ "sorry" ++ "\n"
      else
        content := content ++ line ++ "\n"
      continue
  return content
