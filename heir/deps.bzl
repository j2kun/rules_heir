"""HEIR rules dependencies"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//heir:repo.bzl", _heir_download = "heir_download")
load(":platforms.bzl", "PLATFORMS")

heir_download = _heir_download

def heir_repos():
    for platform in PLATFORMS:
        heir_download(
            name = "heir_%s_%s" % (platform.os, platform.cpu),
            sha256 = platform.sha256,
            url = platform.url,
        )

def heir_register_toolchains():
    """Register the relocatable heir toolchains."""
    heir_repos()

    for platform in PLATFORMS:
        native.register_toolchains(
            "@rules_heir//heir:heir_{os}_{cpu}_toolchain".format(
                os = platform.os,
                cpu = platform.cpu,
            ),
        )
