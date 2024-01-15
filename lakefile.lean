import Lake
open Lake DSL

package «mk-exercise» where
  -- add package configuration options here

lean_lib «MkExercise» where
  -- add library configuration options here

@[default_target]
lean_exe «mk_exercise» where
  root := `MkExercise
  supportInterpreter := true
