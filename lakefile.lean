import Lake
open Lake DSL

package «mk-exercise» where
  -- add package configuration options here
  preferReleaseBuild := false

lean_lib «MkExercise» where
  -- add library configuration options here
  roots := #[`MkExercise]

require Cli from git
  "https://github.com/leanprover/lean4-cli.git" @ "main"

@[default_target]
lean_exe «mk_exercise» where
  buildType := .release
  root := `MkExercise

def runCmdAux (input : String) : IO String := do
  let cmdList := input.splitOn " "
  let cmd := cmdList.head!
  let args := cmdList.tail |>.toArray
  let out ← IO.Process.output {
    cmd := cmd
    args := args
  }
  if out.exitCode != 0 then
    IO.println out.stderr
    throw <| IO.userError s!"Failed to execute: {input}"

  return out.stdout.trimRight

def runCmd (input : String) : IO Unit := do
  let out ← runCmdAux input
  if ! out == "" then
    IO.println out

def checkVersion : IO Unit := do
  let expectedVer := s!"v{Lean.versionString}"
  let actualVer ← runCmdAux "lake exe mk_exercise --version"
  if actualVer != expectedVer then
    throw <| IO.userError s!"Version mismatch: expected {expectedVer}, got {actualVer}"

@[inline]
macro "with_time" x:doElem : doElem => `(doElem| do
  let start_time ← IO.monoMsNow;
  $x;
  let end_time ← IO.monoMsNow;
  IO.println s!"{end_time - start_time}ms")

/-- run test by `lake test` -/
@[test_driver] script test do
  checkVersion
  IO.print "performance test: "
  with_time runCmd "lake exe mk_exercise Test/Performance Test/Out"

  runCmd "lake exe mk_exercise Test/Src Test/Out"
  runCmd "lean --run Test.lean"
  return 0
