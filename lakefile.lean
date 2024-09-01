import Lake
open Lake DSL

package «mk-exercise» where
  -- add package configuration options here
  preferReleaseBuild := true

lean_lib «MkExercise» where
  -- add library configuration options here
  roots := #[`MkExercise]

@[default_target]
lean_exe «mk_exercise» where
  buildType := .release
  root := `MkExercise

/-- run cmd in shell -/
def runCmd (input : String) : IO Unit := do
  let cmdList := input.splitOn " "
  let cmd := cmdList.head!
  let args := cmdList.tail |>.toArray
  let out ← IO.Process.output {
    cmd := cmd
    args := args
  }
  if out.exitCode != 0 then
    IO.eprintln out.stderr
    throw <| IO.userError s!"Failed to execute: {input}"
  if !out.stdout.isEmpty then
    IO.println out.stdout

@[inline]
macro "with_time" x:doElem : doElem => `(doElem| do
  let start_time ← IO.monoMsNow;
  $x;
  let end_time ← IO.monoMsNow;
  IO.println s!"{end_time - start_time}ms")

/-- run test by `lake test` -/
@[test_driver] script test do
  IO.print "performance test: "
  with_time runCmd "lake exe mk_exercise Test/Performance Test/Out"

  runCmd "lake exe mk_exercise Test/Src Test/Out"
  runCmd "lean --run Test.lean"
  return 0
