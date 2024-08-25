import Lake
open Lake DSL

package «mk-exercise» where
  -- add package configuration options here

lean_lib «MkExercise» where
  -- add library configuration options here

@[default_target]
lean_exe «mk_exercise» where
  root := `MkExercise

def runCmd (cmd : String) (args : Array String) : ScriptM Bool := do
  let out ← IO.Process.output {
    cmd := cmd
    args := args
  }
  let hasError := out.exitCode != 0
  if hasError then
    IO.eprint out.stderr
  return hasError

@[inline]
macro "with_time" x:doElem : doElem => `(doElem| do
  let start_time ← IO.monoMsNow;
  $x;
  let end_time ← IO.monoMsNow;
  IO.println s!"{end_time - start_time}ms")

/-- run test by `lake test` -/
@[test_driver] script test do
  IO.print "performance test "
  with_time if ← runCmd "lake" #["exe", "mk_exercise", "Test/Performance", "Test/Out"] then return 1

  if ← runCmd "lake" #["exe", "mk_exercise", "Test/Src", "Test/Out"] then return 1
  if ← runCmd "lean" #["--run", "Test.lean"] then return 1
  return 0
