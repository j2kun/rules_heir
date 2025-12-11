"""Defines metadata about the different heir binaries"""

PLATFORMS = [
    struct(
        os = "linux",
        cpu = "x86_64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2025.12.11/heir-opt",
        heir_opt_sha256 = "a6523653dcfc4745562eff95eeb33728ec5ef022b61f6b265e2b1e283083f26c",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2025.12.11/heir-translate",
        heir_translate_sha256 = "a17b23df835cf008fb5e4e03e221092ac0a62dec8fed522f5873a42fc0cfc820",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    ),
]
