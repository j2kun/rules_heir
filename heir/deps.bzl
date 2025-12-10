"""HEIR rules dependencies"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//heir:repo.bzl", _heir_download = "heir_download")
load(":platforms.bzl", "PLATFORMS")

heir_download = _heir_download

def heir_repos():
    for platform in PLATFORMS:
        heir_download(
            # this defines the name we use in BUILD.bazel to point to the
            # heir-opt binary for the toolchain
            name = "heir_%s_%s" % (platform.os, platform.cpu),
            sha256 = platform.sha256,
            url = platform.url,
        )
