"""Entry point for extensions used by bzlmod."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load(":local_repo.bzl", "local_heir")
load(":platforms.bzl", "PLATFORMS")
load(":repo.bzl", "heir_download")

def make_nightly_url(url):
    parts = url.split("/download/")
    if len(parts) != 2:
        fail("Unexpected URL format: " + url)
    subparts = parts[1].split("/")
    if len(subparts) < 2:
        fail("Unexpected URL format: " + url)
    return parts[0] + "/download/nightly/" + subparts[-1]

def heir_repos(nightly = False):
    for platform in PLATFORMS:
        url_opt = platform.heir_opt_url
        url_translate = platform.heir_translate_url
        sha_opt = platform.heir_opt_sha256
        sha_translate = platform.heir_translate_sha256

        if nightly:
            url_opt = make_nightly_url(url_opt)
            url_translate = make_nightly_url(url_translate)
            sha_opt = ""
            sha_translate = ""

        heir_download(
            # this defines the name we use in BUILD.bazel to point to the
            # heir-opt binary for the toolchain
            name = "heir_%s_%s" % (platform.os, platform.cpu),
            heir_opt_sha256 = sha_opt,
            heir_opt_url = url_opt,
            heir_translate_sha256 = sha_translate,
            heir_translate_url = url_translate,
        )

heir_config = tag_class(attrs = {"nightly": attr.bool(default = False)})

def _heir_repositories(module_ctx):
    nightly = False
    for mod in module_ctx.modules:
        for tag in mod.tags.config:
            if tag.nightly:
                nightly = True
    heir_repos(nightly = nightly)
    return module_ctx.extension_metadata(
        reproducible = not nightly,
        root_module_direct_deps = "all",
        root_module_direct_dev_deps = [],
    )

heir_repositories = module_extension(
    implementation = _heir_repositories,
    tag_classes = {"config": heir_config},
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
