"""Implementation of the heir_translate rule."""

load("@rules_cc//cc/common:cc_common.bzl", "cc_common")
load("@rules_cc//cc/common:cc_info.bzl", "CcInfo")

def _heir_translate_impl(ctx):
    toolchain = ctx.toolchains["//heir:toolchain_type"]
    heir_info = toolchain.heir_info

    generated_file = ctx.outputs.generated_filename
    args = ctx.actions.args()
    args.add_all(ctx.attr.passes)
    args.add_all(["-o", generated_file.path])
    args.add(ctx.file.src)

    ctx.actions.run(
        inputs = ctx.attr.src.files,
        outputs = [generated_file],
        arguments = [args],
        executable = heir_info.heir_translate_path,
        mnemonic = "HeirTranslate",
        progress_message = "Compiling {} with heir-translate...".format(ctx.file.src.short_path),
    )

    cc_info = CcInfo(
        compilation_context = cc_common.create_compilation_context(
            includes = depset([generated_file.dirname]),
        ),
    )

    return [
        DefaultInfo(files = depset([generated_file, ctx.file.src])),
        cc_info,
    ]

heir_translate = rule(
    doc = """
      This rule takes MLIR input and runs heir-translate on it to produce
      a single generated source file in some target language.
      """,
    implementation = _heir_translate_impl,
    attrs = {
        "src": attr.label(
            doc = "A single MLIR source file to translate.",
            allow_single_file = [".mlir"],
        ),
        "passes": attr.string_list(
            doc = """
            The pass flags passed to heir-translate, e.g., --emit-openfhe-pke
            """,
        ),
        "generated_filename": attr.output(
            doc = """
            The name used for the output file, including the extension (e.g.,
            <filename>.rs for rust files).
            """,
            mandatory = True,
        ),
    },
    toolchains = [
        "@bazel_tools//tools/cpp:toolchain_type",
        "@rules_heir//heir:toolchain_type",
    ],
)
