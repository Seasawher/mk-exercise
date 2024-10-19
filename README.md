# mk-exercise

This tool erases parts of Lean code and replaces them with `sorry`. I developed this to make it easier to manage exercises in textbooks written in Lean.

This is inspired by a script in [a glimpse of lean](https://github.com/PatrickMassot/GlimpseOfLean/tree/master).

## How to use

### Basic usage

Add this repository to your `lakefile`:

```lean
require «mk-exercise» from git
  "https://github.com/Seasawher/mk-exercise" @ "main"
```

Don't forget to run `lake update mk-exercise` after editing the `lakefile`. And simply run `lake exe mk_exercise <input_dir> <output_dir>`.

### Setup GitHub Action

GitHub Action allows you to run this every time a particular branch is updated, automatically updating the exercises to the latest state. You may wish to look at [yuma-mizuno/lean-math-workshop](https://github.com/yuma-mizuno/lean-math-workshop), where exercises are managed using this tool.

## Features

* Replace the code enclosed by `-- sorry` with `sorry`, preserving indentation.
* Replace the inline code enclosed by `/-+-/` with `sorry`.
* Replace the code after `/- sorry -/` with sorry.
* Lines ending with `--##` are ignored.
* Blocks enclosed with `--##--` are ignored.

Check the test code for more information.

* [input file](./Test/Src/Solution.lean)
* [expected output](./Test/Exp/Solution.lean)
