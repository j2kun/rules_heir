"""A macro providing an end-to-end test for Lattigo codegen."""

load("@rules_go//go:def.bzl", "go_library")
load("@rules_heir//heir:heir_opt.bzl", "heir_opt")
load("@rules_heir//heir:heir_translate.bzl", "heir_translate")

def _make_split_preprocessing_libs(utils_name, generated_heir_opt_name, heir_translate_flags, common_deps, tags, data, importpath = None):
    utils_go_filename = utils_name + ".go"
    heir_translate(
        name = utils_name + "_translate",
        src = generated_heir_opt_name,
        passes = heir_translate_flags + ["--emit-lattigo-preprocessing", "--package-name=" + utils_name],
        generated_filename = utils_go_filename,
    )
    go_library(
        name = utils_name,
        srcs = [":" + utils_go_filename],
        importpath = importpath,
        deps = common_deps,
        tags = tags,
        data = data,
    )

def heir_lattigo_lib(
        name,
        mlir_src,
        go_library_name = None,
        heir_opt_flags = [],
        heir_translate_flags = [],
        extra_srcs = [],
        data = [],
        tags = [],
        deps = [],
        importpath = None,
        split_preprocessing = True,
        **kwargs):
    """A rule for generating Lattigo code from an MLIR file.

    The input to this macro is primarily an MLIR file produced by some frontend
    tool, such as the heir-py python frontend or torch-mlir. The caller must
    specify via heir_opt_flags exactly what heir-opt pipeline they wish to run
    (this will differ for each application, including but not limited to
    whether the input comes from torch or heir-py).

    The primary output of this macro is a go_library build target for the
    HEIR-compiled Lattigo code. go_library_name controls the name of this
    target.

    This macro requires the user has a workspace dependency on Lattigo with a
    repository called `@com_github_tuneinsight_lattigo_v6`. See
    rules_heir/examples/lattigo/Module.bazel for an example of how to do this.

    Args:
      name: The name of the generated go_library target and package name
      mlir_src: The source mlir file to run through heir-translate
      go_library_name: The name of the generated go library and package
      heir_opt_flags: Flags to pass to heir-opt before heir-translate
      heir_translate_flags: Flags to pass to heir-translate
      extra_srcs: Extra sources to pass to go_library
      data: Data dependencies to be passed to go_library
      tags: Tags to pass to go_library
      deps: Deps to pass to  and go_library
      split_preprocessing: Whether to split preprocessing into a separate library
      **kwargs: Keyword arguments to pass to go_library
    """
    go_package_name = go_library_name or name
    heir_opt_name = "%s_heir_opt" % name
    generated_heir_opt_name = "%s_heir_opt.mlir" % name

    if heir_opt_flags:
        heir_opt(
            name = heir_opt_name,
            src = mlir_src,
            passes = heir_opt_flags,
            generated_filename = generated_heir_opt_name,
            data = data,
        )
    else:
        generated_heir_opt_name = mlir_src

    common_deps = deps + [
        "@com_github_tuneinsight_lattigo_v6//:lattigo",
        "@com_github_tuneinsight_lattigo_v6//core/rlwe",
        "@com_github_tuneinsight_lattigo_v6//schemes/bgv",
        "@com_github_tuneinsight_lattigo_v6//schemes/ckks",
        "@com_github_tuneinsight_lattigo_v6//circuits/ckks/lintrans",
        "@com_github_tuneinsight_lattigo_v6//circuits/ckks/polynomial",
        "@com_github_tuneinsight_lattigo_v6//utils/bignum",
        "@com_github_tuneinsight_lattigo_v6//utils",
        "@com_github_tuneinsight_lattigo_v6//ring",
        "@com_github_tuneinsight_lattigo_v6//circuits/ckks/bootstrapping",
    ]

    if split_preprocessing == True:
        utils_name = go_package_name + "_utils"
        utils_importpath = importpath + "_utils" if importpath else None
        _make_split_preprocessing_libs(utils_name, generated_heir_opt_name, heir_translate_flags, common_deps, tags, data, importpath = utils_importpath)
        common_deps = common_deps + [utils_name]
        utils_import_path = utils_importpath if utils_importpath else (native.package_name() + "/" + utils_name)
        heir_translate_flags = heir_translate_flags + ["--extra-imports=" + utils_import_path, "--emit-lattigo-preprocessed"]
    else:
        heir_translate_flags = heir_translate_flags + ["--emit-lattigo"]

    generated_go_filename = "%s_lib.go" % go_package_name
    heir_translate_flags = heir_translate_flags + ["--package-name=" + go_package_name]
    heir_translate(
        name = name + ".heir_translate_go",
        src = generated_heir_opt_name,
        passes = heir_translate_flags,
        generated_filename = generated_go_filename,
    )
    go_library(
        name = go_package_name,
        importpath = importpath,
        srcs = extra_srcs + [":" + generated_go_filename],
        deps = common_deps,
        tags = tags,
        data = data,
        **kwargs
    )
