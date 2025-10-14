import MkExercise.File
import MkExercise.Extract
import Cli

open Cli System

def runMkExerciseCmd (p : Parsed) : IO UInt32 := do
  let inputDir : FilePath := p.positionalArg! "input_dir" |>.as! String
  let outputDir : FilePath := p.positionalArg! "output_dir" |>.as! String

  let paths ← getLeanFilePaths inputDir
  for path in paths do
    let content ← IO.FS.lines path

    let outputFilePath := outputFilePath
      inputDir.components
      outputDir.components
      path.components

    createFile (genPath outputFilePath) (extractExercise content.toList)
  return 0

def versionString := s!"v{Lean.versionString}"

def mkExerciseCmd : Cmd := `[Cli|
  mk_exercise VIA runMkExerciseCmd; [versionString]
  "This tool erases parts of Lean code and replaces them with sorry."

  ARGS:
    input_dir : String; "The directory containing the solution Lean files."
    output_dir : String; "The directory to write the exercise Lean files."
]
