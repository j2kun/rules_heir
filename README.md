# rules_heir

Bazel rules for the [HEIR](https://github.com/google/heir) compiler.

## Installation

Add the following to your `MODULE.bazel`:

```starlark
bazel_dep(name = "rules_heir", version = "0.0.4")
```

## Usage

### `heir_opt`

Run `heir-opt` on a file.

```starlark
load("@rules_heir//heir:heir_opt.bzl", "heir_opt")

heir_opt(
    name = "my_target",
    src = "input.mlir",
    passes = ["--canonicalize"],
    generated_filename = "output.mlir",
)
```

### `heir_translate`

Run `heir-translate` on a file.

```starlark
load("@rules_heir//heir:heir_translate.bzl", "heir_translate")

heir_translate(
    name = "my_translation",
    src = "input.mlir",
    passes = ["--emit-openfhe-pke"],
    generated_filename = "output.cc",
)
```

## OpenFHE and Lattigo macros

The files `heir/openfhe.bzl` and `heir/lattigo.bzl` contain macros that make it
easier to integrate HEIR outputs with OpenFHE and Lattigo. The examples
directory `examples/openfhe` and `examples/lattigo` show usage and the macros
themselves have docstrings for detailed options.

## Using Local HEIR Binaries

By default, `rules_heir` downloads pre-compiled binaries. If you want to use a
local build of HEIR (e.g., for development), add the following to your
`MODULE.bazel`:

```starlark
local_heir_repositories = use_extension("@rules_heir//heir:extensions.bzl", "local_heir_repositories")
local_heir_repositories.config(path = "/path/to/heir/bazel-bin/tools")
use_repo(local_heir_repositories, "heir_local")

register_toolchains(
    "@heir_local//:heir_local_toolchain",
)
```
