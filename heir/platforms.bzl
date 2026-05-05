"""Defines metadata about the different heir binaries"""

PLATFORMS = [
    struct(
        os = "linux",
        cpu = "x86_64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2026.05.01/heir-opt",
        heir_opt_sha256 = "e70f3b047d0832d350b58b50b74dcdb29132ecbe33535a3c08b28ecceea0d42a",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2026.05.01/heir-translate",
        heir_translate_sha256 = "a002403329fd808bac8d3e8d2c80927f713d9a918a144f6bbc1a799560b36577",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    ),
]
