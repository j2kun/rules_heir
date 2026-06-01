"""Defines metadata about the different heir binaries"""

PLATFORMS = [
    struct(
        os = "linux",
        cpu = "x86_64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2026.06.01/heir-opt-manylinux_2_28_x86_64",
        heir_opt_sha256 = "be6a00452f5e214b450d1aa6f44c8589c99078873e2c92fef3de43af6ebbd5cb",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2026.06.01/heir-translate-manylinux_2_28_x86_64",
        heir_translate_sha256 = "804af0215142c4e82e98996eb0dba2d8b8800badd28ae2c514dd20e86b190307",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    ),
    struct(
        os = "macos",
        cpu = "arm64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2026.06.01/heir-opt-macosx_11_0_arm64",
        heir_opt_sha256 = "0edeec2ce1ce7c0124813d948428eb1ce85d24eb89cd255790cf4613f7f22ae5",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2026.06.01/heir-translate-macosx_11_0_arm64",
        heir_translate_sha256 = "147d9280014e18c706e0df1f5b1e2ae0b2f816deba195556e019c42cf51ca13a",
        exec_compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:aarch64",
        ],
    ),
    struct(
        os = "linux",
        cpu = "aarch64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2026.06.01/heir-opt-manylinux_2_28_aarch64",
        heir_opt_sha256 = "3e54235d66ca614b21e3754019484bb4e45cad55465ee0d8fcb391cb05af4920",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2026.06.01/heir-translate-manylinux_2_28_aarch64",
        heir_translate_sha256 = "fbf019bf584ac223f7ea98b535cadaf8b40ddb468bdd8427ee963f399d25a262",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:aarch64",
        ],
    ),
]
