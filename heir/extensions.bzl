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

def heir_repos(nightly = False, overrides = {}):
    for key in overrides:
        found = False
        for platform in PLATFORMS:
            platform_key = "%s_%s" % (platform.os, platform.cpu)
            if key == platform_key:
                found = True
                break
        if not found:
            fail("Override specified for unsupported platform: %s" % key)

    for platform in PLATFORMS:
        key = "%s_%s" % (platform.os, platform.cpu)
        url_opt = platform.heir_opt_url
        url_translate = platform.heir_translate_url
        sha_opt = platform.heir_opt_sha256
        sha_translate = platform.heir_translate_sha256

        if key in overrides:
            override = overrides[key]
            if override.heir_opt_url:
                url_opt = override.heir_opt_url
                sha_opt = override.heir_opt_sha256
            if override.heir_translate_url:
                url_translate = override.heir_translate_url
                sha_translate = override.heir_translate_sha256

        if nightly:
            if not (key in overrides and overrides[key].heir_opt_url):
                url_opt = make_nightly_url(url_opt)
                sha_opt = ""
            if not (key in overrides and overrides[key].heir_translate_url):
                url_translate = make_nightly_url(url_translate)
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

platform_config = tag_class(
    attrs = {
        "os": attr.string(mandatory = True, values = ["linux", "macos"]),
        "cpu": attr.string(mandatory = True, values = ["x86_64", "arm64", "aarch64"]),
        "heir_opt_url": attr.string(),
        "heir_opt_sha256": attr.string(),
        "heir_translate_url": attr.string(),
        "heir_translate_sha256": attr.string(),
    }
)

def _heir_repositories(module_ctx):
    nightly = False
    overrides = {}
    for mod in module_ctx.modules:
        for tag in mod.tags.config:
            if tag.nightly:
                nightly = True
        for tag in mod.tags.platform:
            key = "%s_%s" % (tag.os, tag.cpu)
            overrides[key] = struct(
                heir_opt_url = tag.heir_opt_url,
                heir_opt_sha256 = tag.heir_opt_sha256,
                heir_translate_url = tag.heir_translate_url,
                heir_translate_sha256 = tag.heir_translate_sha256,
            )

    heir_repos(nightly = nightly, overrides = overrides)

    reproducible = not nightly
    for override in overrides.values():
        if override.heir_opt_url and not override.heir_opt_sha256:
            reproducible = False
        if override.heir_translate_url and not override.heir_translate_sha256:
            reproducible = False

    return module_ctx.extension_metadata(
        reproducible = reproducible,
        root_module_direct_deps = "all",
        root_module_direct_dev_deps = [],
    )

heir_repositories = module_extension(
    implementation = _heir_repositories,
    tag_classes = {
        "config": heir_config,
        "platform": platform_config,
    },
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
