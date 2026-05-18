"""Defines metadata about the different heir binaries"""

PLATFORMS = [
    struct(
        os = "linux",
        cpu = "x86_64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2026.05.18/heir-opt-manylinux_2_28_x86_64",
        heir_opt_sha256 = "9ca21e4263d2141398ce65238e5b984c1a8c9d41bd7eb186f048055e9626365b",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2026.05.18/heir-translate-manylinux_2_28_x86_64",
        heir_translate_sha256 = "5fd90b5b4c8c1ac7019fe41c430afa02426e6f3550293190ba5efc15ece2d315",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    ),
    struct(
        os = "macos",
        cpu = "arm64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2026.05.18/heir-opt-macosx_11_0_arm64",
        heir_opt_sha256 = "48369c2731e68e6d8a69462dc30baa82b18588d040559d2ca1ae13f3e03c9bb5",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2026.05.18/heir-translate-macosx_11_0_arm64",
        heir_translate_sha256 = "1ff77a23c8022ddb181cd3d38f38d706b1949503e76e7fa5524d9946ae115d37",
        exec_compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:aarch64",
        ],
    ),
    struct(
        os = "linux",
        cpu = "aarch64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2026.05.18/heir-opt-manylinux_2_28_aarch64",
        heir_opt_sha256 = "911d52a81cd770541a98e98e309f365038273dbd3161baa90775d40cfcf8eba2",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2026.05.18/heir-translate-manylinux_2_28_aarch64",
        heir_translate_sha256 = "288a30a70ed6f4f7b09c6b47bccf1d55feead3db5132bb57e92dc460b4f9f639",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:aarch64",
        ],
    ),
]
