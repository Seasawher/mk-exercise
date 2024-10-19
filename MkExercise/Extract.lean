open System

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

def findWhereAll (line : String) (tgt : String) : List Nat := Id.run do
  let mut result := []
  for i in [0 : line.length - tgt.length + 1] do
    let rest := line.drop i
    if rest.startsWith tgt then
      result := i :: result
  return result.reverse

#guard [9, 20, 32] = findWhereAll
  (line := "hello := /-+-/ fuga /-+-/ greet /-+-/")
  (tgt := "/-+-/")

/-- handle ignore pattern -/
def filterIgnored (lines : List String) : List String := Id.run do
  let mut result := []
  let mut «--##--» := false
  for line in lines do
    if line.trim.endsWith "--##" then
      continue

    -- ignore pattern for a block
    if line.trim.endsWith "--##--" then
      «--##--» := ! «--##--»
      continue
    if «--##--» then
      continue

    result := line :: result
  return result.reverse

/-- helper function for `replaceInlineSorry` -/
def replaceFirstInlineSorry (line : String) : String := Id.run do
  let occurence := findWhereAll line "/-+-/"

  if occurence.length < 2 then
    panic! "The number of `/-+-/` is odd."

  let fst := occurence[0]!
  let snd := occurence[1]!
  return line.take fst ++ "sorry" ++ line.drop (snd + 5)

#guard replaceFirstInlineSorry "hello := /-+-/ fuga /-+-/ greet /-+-/" = "hello := sorry greet /-+-/"

/-- replace `/-+-/ text /-+-/` to `sorry` -/
def replaceInlineSorry (line : String) : String := Id.run do
  let mut current := line
  while (findWhereAll current "/-+-/").length ≥ 2 do
    current := replaceFirstInlineSorry current
  return current

#guard replaceInlineSorry "hello := /-+-/ fuga /-+-/ greet /-+-/" = "hello := sorry greet /-+-/"
#guard replaceInlineSorry "hello := /-+-/ fuga /-+-/ greet /-+-/ hoge /-+-/" = "hello := sorry greet sorry"

/-- remove some content from the given content
and replace it with `sorry` -/
def extractExercise (lines : List String) : String := Id.run do
  let lines := filterIgnored lines
  let mut listen := true
  let mut content := ""
  for line in lines do
    if let some index := findWhere line "-- sorry" then
      listen := ! listen
      if ! listen then
        content ++= line.take index ++ "sorry\n"
      continue

    if listen then
      if let some index := findWhere line "/- sorry -/" then
        content ++= replaceInlineSorry <| line.take index ++ "sorry\n"
      else
        content ++= replaceInlineSorry line ++ "\n"
      continue

  if ! listen then
    panic! "Unexpected file ending. This file contains unclosed `-- sorry`."

  return content
