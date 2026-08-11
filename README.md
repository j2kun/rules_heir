# rules_heir

Bazel rules for the [HEIR](https://github.com/google/heir) compiler.

## Installation

Add the following to your `MODULE.bazel`:

```starlark
bazel_dep(name = "rules_heir", version = "0.1.1")
```

## Supported Platforms

`rules_heir` fetches pre-built binaries for the following platforms:

-   Linux x86_64 (requires glibc >= 2.28)
-   Linux aarch64 (requires glibc >= 2.28)
-   macOS arm64

If your platform is not supported or doesn't meet the requirements, you will see
an error during dependency fetching. In that case, you can use local binaries as
described below.

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

## Using Nightly HEIR Binaries

If you want to use the latest nightly builds of HEIR instead of the pinned
release binaries, you can opt-in by configuring the `heir_repositories`
extension in your `MODULE.bazel`.

See
[examples/nightly](file:///usr/local/google/home/jkun/fhe/rules_heir/examples/nightly)
for a working example.

Briefly, you need to configure the extension as follows:

```starlark
heir_repos = use_extension("@rules_heir//heir:extensions.bzl", "heir_repositories")
heir_repos.config(nightly = True)
use_repo(
    heir_repos,
    "heir_linux_x86_64",
    "heir_macos_arm64",
    "heir_linux_aarch64",
)
```

**Note on Caching:** Bazel caches external repositories. Because the nightly URL
remains the same (`.../download/nightly/...`), Bazel will not automatically
detect updates to the nightly binaries. To force Bazel to fetch the latest
nightly binary, you must run:

```bash
bazel clean --expunge
```

or manually delete the corresponding repository from your Bazel external cache.

## Using Custom HEIR Binaries (URLs and Hashes)

If you want to use specific builds of HEIR (e.g., a specific release or a pinned
nightly build), you can configure the `heir_repositories` extension to override
the download URLs and SHA256 hashes on a per-platform basis.

See [examples/custom_urls](examples/custom_urls) for a working example.

Briefly, you need to configure the extension as follows:

```starlark
heir_repos = use_extension("@rules_heir//heir:extensions.bzl", "heir_repositories")
heir_repos.platform(
    os = "linux",
    cpu = "x86_64",
    heir_opt_url = "https://github.com/google/heir/releases/download/nightly-2026.08.10/heir-opt-manylinux_2_28_x86_64",
    heir_opt_sha256 = "375fee680dad059008366c16ca106f07129fa3e8bb65f8af3171e76b903240f5",
    heir_translate_url = "https://github.com/google/heir/releases/download/nightly-2026.08.10/heir-translate-manylinux_2_28_x86_64",
    heir_translate_sha256 = "c69a5604f63667e35d6f0cee2c15ee9caf3c5c73165772ea7e20eb99076e44d6",
)
use_repo(
    heir_repos,
    "heir_linux_x86_64",
    "heir_macos_arm64",
    "heir_linux_aarch64",
)
```

You only need to specify overrides for the platforms you wish to customize.
Other platforms will continue to use the default pinned releases.
