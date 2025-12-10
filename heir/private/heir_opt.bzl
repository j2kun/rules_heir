"""Implementation of the heir_opt rule."""

def _heir_opt_impl(ctx):
    """
    Implementation of the heir_opt rule.
    """

    toolchain = ctx.toolchains["//heir:toolchain_type"]
    heir_info = toolchain.heir_info

    output_file = ctx.actions.declare_file(ctx.attr.name + ".out")

    ctx.actions.run(
        outputs = [output_file],
        inputs = [ctx.file.src],
        executable = heir_info.heir_opt_path,
        arguments = [
            "--input",
            ctx.file.src.path,
            "--output",
            output_file.path,
            "--optimize",
        ],
        mnemonic = "HeirOpt",
        progress_message = "Compiling {} with heir-opt...".format(ctx.file.src.short_path),
    )

    return [DefaultInfo(
        files = depset([output_file]),
    )]

heir_opt = rule(
    implementation = _heir_opt_impl,
    attrs = {
        "src": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "The input file to be optimized.",
        ),
    },
    toolchains = ["@rules_heir//heir:toolchain_type"],
)
