load("@rules_heir//heir:toolchain.bzl", "heir_toolchain")

package(default_visibility = ["//visibility:public"])

exports_files(["heir-opt", "heir-translate"])

# These provide toolchain definitions for local binaries. To use these, see
# local_heir_repositories and examples/local_heir. The name `@heir_local` is
# hard-coded in local_heir_repo.
heir_toolchain(
    name = "heir_local_toolchain_impl",
    heir_opt = "@heir_local//:heir-opt",
    heir_translate = "@heir_local//:heir-translate",
    visibility = ["//visibility:public"],
)

toolchain(
    name = "heir_local_toolchain",
    toolchain = ":heir_local_toolchain_impl",
    toolchain_type = "@rules_heir//heir:toolchain_type",
    visibility = ["//visibility:public"],
)
