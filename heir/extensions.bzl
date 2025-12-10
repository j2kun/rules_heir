"""Entry point for extensions used by bzlmod."""

load("@rules_heir//heir:deps.bzl", "heir_repos")

def _heir_repositories(module_ctx):
    heir_repos()
    return module_ctx.extension_metadata(
        reproducible = True,
        root_module_direct_deps = "all",
        root_module_direct_dev_deps = [],
    )

heir_repositories = module_extension(
    implementation = _heir_repositories,
)
