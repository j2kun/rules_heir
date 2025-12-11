"""Entry point for extensions used by bzlmod."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load(":local_repo.bzl", "local_heir")
load(":platforms.bzl", "PLATFORMS")
load(":repo.bzl", "heir_download")

def heir_repos():
    for platform in PLATFORMS:
        heir_download(
            # this defines the name we use in BUILD.bazel to point to the
            # heir-opt binary for the toolchain
            name = "heir_%s_%s" % (platform.os, platform.cpu),
            heir_opt_sha256 = platform.heir_opt_sha256,
            heir_opt_url = platform.heir_opt_url,
            heir_translate_sha256 = platform.heir_translate_sha256,
            heir_translate_url = platform.heir_translate_url,
        )

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

def local_heir_repo(module_ctx):
    for mod in module_ctx.modules:
        if mod.is_root:
            for setting in mod.tags.config:
                local_heir(name = "heir_local", path = setting.path)

def _local_heir_repositories(module_ctx):
    local_heir_repo(module_ctx)

    return module_ctx.extension_metadata(
        # Because it reads the host system state, it is not reproducible.
        reproducible = False,
        # requires user to explicitly declare they're using the local repo.
        root_module_direct_deps = [],
        root_module_direct_dev_deps = [],
    )

local_heir_config = tag_class(attrs = {"path": attr.string(mandatory = True)})

local_heir_repositories = module_extension(
    implementation = _local_heir_repositories,
    tag_classes = {
        "config": local_heir_config,
    },
)
