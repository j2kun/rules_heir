"""Defines metadata about the different heir binaries"""

PLATFORMS = [
    struct(
        os = "linux",
        cpu = "x86_64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2026.08.01/heir-opt-manylinux_2_28_x86_64",
        heir_opt_sha256 = "201af628e0a430305433b0863d6b69f5c09e76dd457d8df1d828ac8f7adc4e8f",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2026.08.01/heir-translate-manylinux_2_28_x86_64",
        heir_translate_sha256 = "acebdcac0d1d004eb449fddb7dcc0afa24760e427199dde9615fbc5ed8e372f2",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    ),
    struct(
        os = "macos",
        cpu = "arm64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2026.08.01/heir-opt-macosx_11_0_arm64",
        heir_opt_sha256 = "16ed5fb539bcb40544042a9cad270b1570a62911cced20e9a3f953bd953b3760",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2026.08.01/heir-translate-macosx_11_0_arm64",
        heir_translate_sha256 = "1e220708c069d51308e3c5fabc411b0358a444a7712992183d21797f86ebcb24",
        exec_compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:aarch64",
        ],
    ),
    struct(
        os = "linux",
        cpu = "aarch64",
        heir_opt_url = "https://github.com/google/heir/releases/download/v2026.08.01/heir-opt-manylinux_2_28_aarch64",
        heir_opt_sha256 = "d8be4952173e1dc86894bea875fc9f3d529839e1b93f2694db34d078ffdf5c77",
        heir_translate_url = "https://github.com/google/heir/releases/download/v2026.08.01/heir-translate-manylinux_2_28_aarch64",
        heir_translate_sha256 = "d88890971d454dd0b889d613318ff406cce54e37d8a146e58d9d3533da8db44a",
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:aarch64",
        ],
    ),
]
