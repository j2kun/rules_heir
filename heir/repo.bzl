"""Rules for downloading hermetic heir binaries"""

def _heir_opt_download(ctx):
    ctx.report_progress("Downloading heir-opt")

    binary_name = "heir-opt"
    if ctx.attr.heir_opt_local_path:
        ctx.symlink(ctx.attr.heir_opt_local_path, binary_name)
    else:
        if not ctx.attr.heir_opt_url:
            fail("Either 'heir_opt_local_path' or 'heir_opt_heir_opt_url' must be specified for heir_repository.")
        ctx.download(
            url = ctx.attr.heir_opt_url,
            output = binary_name,
            sha256 = ctx.attr.heir_opt_sha256,
            executable = True,
        )

def _heir_translate_download(ctx):
    ctx.report_progress("Downloading heir-translate")

    binary_name = "heir-translate"
    if ctx.attr.heir_translate_local_path:
        ctx.symlink(ctx.attr.heir_translate_local_path, binary_name)
    else:
        if not ctx.attr.heir_translate_url:
            fail("Either 'heir_translate_local_path' or 'heir_translate_heir_translate_url' must be specified for heir_repository.")
        ctx.download(
            url = ctx.attr.heir_translate_url,
            output = binary_name,
            sha256 = ctx.attr.heir_translate_sha256,
            executable = True,
        )

def _heir_download_impl(ctx):
    _heir_opt_download(ctx)
    _heir_translate_download(ctx)

    ctx.report_progress("Creating heir toolchain bazel file")
    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
    )

heir_download = repository_rule(
    implementation = _heir_download_impl,
    attrs = {
        "heir_opt_url": attr.string(
            doc = "URL of the heir-opt binary.",
        ),
        "heir_opt_sha256": attr.string(
            doc = "SHA256 checksum of the heir-opt binary.",
        ),
        "heir_opt_local_path": attr.string(
            doc = "Absolute path to a local heir-opt binary. If set, url and sha256 are ignored.",
        ),
        "heir_translate_url": attr.string(
            doc = "URL of the heir-translate binary.",
        ),
        "heir_translate_sha256": attr.string(
            doc = "SHA256 checksum of the heir-translate binary.",
        ),
        "heir_translate_local_path": attr.string(
            doc = "Absolute path to a local heir-translate binary. If set, url and sha256 are ignored.",
        ),
        "_build_tpl": attr.label(
            default = Label("@rules_heir//heir/private:BUILD.dist.bazel.tpl"),
        ),
    },
    doc = "Downloads heir-opt and exposes it to bazel",
)
