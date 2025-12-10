"""Rules for downloading hermetic heir binaries"""

def _heir_download_impl(ctx):
    ctx.report_progress("Downloading heir-opt")

    binary_name = "heir-opt"
    if ctx.attr.local_path:
        ctx.symlink(ctx.attr.local_path, binary_name)
    else:
        if not ctx.attr.url:
            fail("Either 'local_path' or 'url' must be specified for heir_repository.")
        ctx.download(
            url = ctx.attr.url,
            output = binary_name,
            sha256 = ctx.attr.sha256,
            executable = True,
        )

    ctx.report_progress("Creating heir-opt toolchain files")
    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
    )

heir_download = repository_rule(
    implementation = _heir_download_impl,
    attrs = {
        "url": attr.string(
            doc = "URL of the heir binary.",
        ),
        "sha256": attr.string(
            doc = "SHA256 checksum of the binary.",
        ),
        "local_path": attr.string(
            doc = "Absolute path to a local binary. If set, url and sha256 are ignored.",
        ),
        "_build_tpl": attr.label(
            default = Label("@rules_heir//heir/private:BUILD.dist.bazel.tpl"),
        ),
    },
    doc = "Downloads heir-opt and exposes it to bazel",
)
