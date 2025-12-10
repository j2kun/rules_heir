"""The toolchain definition"""

HeirInfo = provider(
    doc = "Information about how to invoke heir binaries.",
    fields = {
        "heir_opt_path": "File: A label which points to the heir-opt binary",
    },
)

def _heir_toolchain_impl(ctx):
    """
    Converts the attributes of the heir_toolchain rule into an HeirInfo provider.
    And wraps it in a platform_common.ToolchainInfo.
    """

    # We wrap our language-specific provider (HeirInfo) inside the
    # generic ToolchainInfo provider. This is required by Bazel's resolution engine.
    toolchain_info = platform_common.ToolchainInfo(
        heir_info = HeirInfo(
            heir_opt_path = ctx.file.heir_opt,
        ),
    )
    return [toolchain_info]

heir_toolchain = rule(
    implementation = _heir_toolchain_impl,
    attrs = {
        "heir_opt": attr.label(
            mandatory = True,
            allow_single_file = True,
            cfg = "exec",
        ),
    },
)
