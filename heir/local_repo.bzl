"""Rules for symlinking local heir binaries into a bazel repository"""

def _local_heir_impl(ctx):
    heir_opt_path = ctx.path(ctx.attr.path).get_child("heir-opt")
    heir_translate_path = ctx.path(ctx.attr.path).get_child("heir-translate")

    if not heir_opt_path.exists:
        fail("heir-opt not found at {}".format(heir_opt_path))
    if not heir_translate_path.exists:
        fail("heir-translate not found at {}".format(heir_translate_path))

    ctx.symlink(heir_opt_path, "heir-opt")
    ctx.symlink(heir_translate_path, "heir-translate")

    ctx.file("MODULE.bazel", "")
    ctx.report_progress("Creating heir toolchain bazel file")
    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
    )

local_heir = repository_rule(
    implementation = _local_heir_impl,
    attrs = {
        "path": attr.string(
            doc = "Path to the directory containing the HEIR toolchain (heir-opt, etc.)",
        ),
        "_build_tpl": attr.label(
            default = Label("@rules_heir//heir/private:BUILD.local.bazel.tpl"),
        ),
    },
    doc = "Symlinks heir binaries and exposes them to bazel",
)
