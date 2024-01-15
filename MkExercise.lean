import MkExercise.Basic
import MkExercise.Extract

open Lake DSL System

def main (args : List String) : IO UInt32 := do
  if args.length != 2 then
    IO.eprintln s!"usage: mk_exercise <input_dir> <output_dir>"
    return 1

  let inputDir : FilePath := args.get! 0
  let outputDir : FilePath := args.get! 1

  let paths ← getLeanFilePaths inputDir

  for path in paths do
    let content ← IO.FS.lines path

    let outputFilePath := outputFilePath
      inputDir.components
      outputDir.components
      path.components

    createFile (genPath outputFilePath) (extractExercise content.toList)
  return 0
