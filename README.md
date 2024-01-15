# mk-exercise

This tool erases parts of Lean code and replaces them with `sorry`. I developed this to make it easier to manage exercises in textbooks written in Lean.

This is inspired by a script in [a glimpse of lean](https://github.com/PatrickMassot/GlimpseOfLean/tree/master).

## How to use

Add this repository to your `lakefile`:

```lean
require mk-exercise from git
  "https://github.com/Seasawher/mk-exercise" @ "main"
```

Don't forget to run `lake update mdgen` after editing the `lakefile`. And simply run `lake exe mk_exercise <input_dir> <output_dir>`.

# Features

* Replace the code enclosed by `-- sorry` with `sorry`, preserving indentation.
* Replace the code after `/- sorry -/` with sorry.

Check the test code for more information.

* [input file](./Test/Src/Solution.lean)
* [expected output](./Test/Exp/Solution.lean)
