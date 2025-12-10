"""Defines metadata about the different heir binaries"""

PLATFORMS = [
    struct(
        os = "linux",
        cpu = "x86_64",
        # FIXME: replace with actual releases and hashes
        heir_opt_url = "https://github.com/google/heir/releases/download/nightly/heir-opt",
        heir_opt_sha256 = "db854795c26f7244a514c9ae9708280376b7c12da5329302ba88b67145e8b11d",
        heir_translate_url = "https://github.com/google/heir/releases/download/nightly/heir-translate",
        heir_translate_sha256 = "cd91c75c647ef0b2e7d2e58a0b867ce6d8934c9dd8950323395ec08c316083db",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    ),
]
