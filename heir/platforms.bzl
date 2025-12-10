"""Defines metadata about the different heir-opt binaries"""

PLATFORMS = [
    struct(
        os = "linux",
        cpu = "x86_64",
        # FIXME: replace with actual releases and hashes
        url = "https://github.com/google/heir/releases/download/nightly/heir-opt",
        sha256 = "cd3216bd72fa4fe3b76fc7f4e2f1004d75e42495d515c09b53d79cba3700dd7b",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    ),
]
