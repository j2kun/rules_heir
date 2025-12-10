"""Implementation of the heir_opt rule."""

def _heir_opt_impl(ctx):
    """
    Implementation of the heir_opt rule.
    """
    toolchain = ctx.toolchains["//heir:toolchain_type"]
    heir_info = toolchain.heir_info

    generated_file = ctx.outputs.generated_filename
    args = ctx.actions.args()
    pass_flags_location_expanded = [ctx.expand_location(flag, ctx.attr.data) for flag in ctx.attr.passes]
    args.add_all(pass_flags_location_expanded)
    args.add_all(["-o", generated_file.path])
    args.add(ctx.file.src)
    env_vars = {}
    # TODO: add yosys support

    ctx.actions.run(
        inputs = ctx.attr.src.files,
        tools = ctx.files.data,
        outputs = [generated_file],
        arguments = [args],
        env = env_vars,
        executable = heir_info.heir_opt_path,
        mnemonic = "HeirOpt",
        progress_message = "Compiling {} with heir-opt...".format(ctx.file.src.short_path),
    )
    return [
        DefaultInfo(files = depset([generated_file, ctx.file.src])),
    ]

heir_opt = rule(
    doc = """
      This rule takes MLIR input and runs heir-opt on it to produce
      a single output file after applying the given MLIR passes.
      """,
    implementation = _heir_opt_impl,
    attrs = {
        "src": attr.label(
            doc = "A single MLIR source file to opt.",
            allow_single_file = [".mlir"],
        ),
        "data": attr.label_list(
            doc = "Additional files needed for running heir-opt. Example: yosys techmap files.",
            allow_files = True,
        ),
        "passes": attr.string_list(
            doc = """
            The pass flags passed to heir-opt, e.g., --canonicalize
            """,
        ),
        "generated_filename": attr.output(
            doc = """
            The name used for the output file, including the extension (e.g.,
            <filename>.mlir).
            """,
            mandatory = True,
        ),
    },
    toolchains = ["@rules_heir//heir:toolchain_type"],
)
