"""Defines metadata about the different heir-opt binaries"""

PLATFORMS = [
    struct(
        os = "linux",
        cpu = "x86_64",
        # FIXME: replace with actual releases and hashes
        url = "https://github.com/google/heir/releases/download/nightly/heir-opt",
        sha256 = "db854795c26f7244a514c9ae9708280376b7c12da5329302ba88b67145e8b11d",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    ),
]
