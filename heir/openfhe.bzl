"""A macro providing an end-to-end library for OpenFHE codegen."""

load("@pybind11_bazel//:build_defs.bzl", "pybind_extension")
load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_heir//heir:heir_opt.bzl", "heir_opt")
load("@rules_heir//heir:heir_translate.bzl", "heir_translate")

OPENFHE_COPTS = [
    "-Wno-non-virtual-dtor",
    "-Wno-shift-op-parentheses",
    "-Wno-unused-private-field",
    "-fexceptions",
]

OPENFHE_LINKOPTS = [
    "-fopenmp",
    "-lomp",
]

OPENMP_COPTS = [
    "-fopenmp",
    "-Xpreprocessor",
    "-Wno-unused-command-line-argument",
]

def heir_openfhe_lib(
        name,
        mlir_src,
        generated_lib_header,
        cc_lib_target_name = None,
        pybind_target_name = None,
        heir_opt_flags = [],
        heir_translate_flags = [],
        externalize_constants = True,
        ext_const_output_dir = "",
        data = [],
        tags = [],
        deps = [],
        cc_lib_copts = None,
        cc_lib_linkopts = None,
        generate_debug_helper = False,
        **kwargs):
    """A rule for running HEIR to generate an OpenFHE C++ library.

    The input to this macro is primarily an MLIR file produced by some frontend
    tool, such as the heir-py python frontend or torch-mlir. The caller must
    specify via heir_opt_flags exactly what heir-opt pipeline they wish to run
    (this will differ for each application, including but not limited to
    whether the input comes from torch or heir-py).

    The primary output of this macro are the targets:

    - a cc_library build target for the HEIR-compiled OpenFHE C++ code.
      cc_lib_target_name controls the name of this target.
    - a pybind_extension build target for python bindings to the cc_library,
      which allows one to write the calling code in Python. pybind_target_name
      controls the name of the this target.

    This macro requires the user has a workspace dependency on OpenFHE with a
    repository called `@openfhe`. The easiest way to achieve this is by adding
    the latest version of OpenFHE from the Bazel Central Registry to your
    MODULE.bazel file.

    Cf. https://registry.bazel.build/modules/openfhe, and for example:

        bazel_dep(name = "openfhe", version = "1.4.2.bcr.2")

    Args:
      name: The name of the cc_test target and the generated .cc file basename.
      mlir_src: The source mlir file to run through heir-translate
      generated_lib_header: The name of the generated .h file (explicit
        because it needs to be manually #include'd in the test_src file)
      cc_lib_target_name: The name of the generated cc_library target
      pybind_target_name: The name of the generated pybind_extension target
      heir_opt_flags: Flags to pass to heir-opt before heir-translate
      heir_translate_flags: Flags to pass to heir-translate
      externalize_constants: If True, externalize constants.
      ext_const_output_dir: If set, externalize constants to this directory.
      data: Data dependencies to be passed to heir_opt
      tags: Tags to pass to cc_test and cc_library
      deps: Deps to pass to cc_test and cc_library
      cc_lib_copts: copts to pass to cc_library targets
      cc_lib_linkopts: linkopts to pass to cc_library_targets,
      generate_debug_helper: Flag for generating default debug helper code,
      **kwargs: Keyword arguments to pass to cc_library and cc_test.
    """
    if cc_lib_copts == None:
        cc_lib_copts = OPENFHE_COPTS + select({
            "@platforms//os:linux": OPENMP_COPTS,
            "@platforms//os:macos": [],
            "//conditions:default": OPENMP_COPTS,
        })
    if cc_lib_linkopts == None:
        cc_lib_linkopts = select({
            "@platforms//os:linux": OPENFHE_LINKOPTS,
            "@platforms//os:macos": [],
            "//conditions:default": OPENFHE_LINKOPTS,
        })

    cc_codegen_target = name + ".heir_translate_cc"
    h_codegen_target = name + ".heir_translate_h"
    pybind_codegen_target = name + ".heir_translate_pybind"
    generated_cc_filename = "%s_lib.inc.cc" % name
    heir_opt_name = "%s_heir_opt" % name
    generated_heir_opt_name = "%s_heir_opt.mlir" % name

    heir_translate_source_relative_flags = heir_translate_flags + ["--openfhe-include-type=source-relative"]

    cc_lib_target = cc_lib_target_name
    if not cc_lib_target:
        cc_lib_target = "_heir_%s" % name

    pybind_target = pybind_target_name
    if not pybind_target:
        pybind_target = "_heir_%s" % name

    if heir_opt_flags or externalize_constants:
        heir_opt(
            name = heir_opt_name,
            src = mlir_src,
            passes = heir_opt_flags,
            generated_filename = generated_heir_opt_name,
            data = data,
            externalize_constants = externalize_constants,
            ext_const_output_dir = ext_const_output_dir,
        )
    else:
        generated_heir_opt_name = mlir_src

    if generate_debug_helper:
        generated_debug_h_filename = "%s_debug_helper.h" % name
        generated_debug_cc_filename = "%s_debug_helper.cc" % name
        heir_translate_debug_header_flags = heir_translate_source_relative_flags + [
            "--emit-openfhe-pke-debug-header",
        ]

        debug_header_codegen_target = name + ".heir_debug_h"
        heir_translate(
            name = debug_header_codegen_target,
            src = generated_heir_opt_name,
            passes = heir_translate_debug_header_flags,
            generated_filename = generated_debug_h_filename,
        )

        heir_translate_source_relative_flags = heir_translate_source_relative_flags + [
            "--openfhe-debug-helper-include-path=%s" % generated_debug_h_filename,
        ]

        heir_translate_debug_flags = heir_translate_source_relative_flags + [
            "--emit-openfhe-pke-debug",
        ]

        cc_debug_codegen_target = name + ".heir_debug_cc"
        heir_translate(
            name = cc_debug_codegen_target,
            src = generated_heir_opt_name,
            passes = heir_translate_debug_flags,
            generated_filename = generated_debug_cc_filename,
        )

        debug_lib_target = "%s_debug_helper_lib" % name
        cc_library(
            name = debug_lib_target,
            srcs = [generated_debug_cc_filename],
            hdrs = [generated_debug_h_filename],
            deps = deps + ["@openfhe//:pke"],
            tags = tags,
            data = data,
            copts = cc_lib_copts,
            linkopts = cc_lib_linkopts,
            **kwargs
        )

        deps = deps + [debug_lib_target]

    heir_translate_cc_flags = heir_translate_source_relative_flags + ["--emit-openfhe-pke"]
    heir_translate_h_flags = heir_translate_source_relative_flags + ["--emit-openfhe-pke-header"]

    heir_translate(
        name = cc_codegen_target,
        src = generated_heir_opt_name,
        passes = heir_translate_cc_flags,
        generated_filename = generated_cc_filename,
    )
    heir_translate(
        name = h_codegen_target,
        src = generated_heir_opt_name,
        passes = heir_translate_h_flags,
        generated_filename = generated_lib_header,
    )

    cc_lib_data = data
    if heir_opt_flags or externalize_constants:
        cc_lib_data = data + [":" + heir_opt_name]

    cc_library(
        name = cc_lib_target,
        srcs = [generated_cc_filename],
        hdrs = [generated_lib_header],
        deps = deps + ["@openfhe//:pke"],
        tags = tags,
        data = cc_lib_data,
        copts = cc_lib_copts,
        linkopts = cc_lib_linkopts,
        **kwargs
    )

    # add Python bindings on top
    generated_pybind_cc_name = "%s_bindings.cpp" % name
    pybind_flags = heir_translate_flags + [
        "--openfhe-include-type=source-relative",
        "--emit-openfhe-pke-pybind",
        "--pybind-header-include=%s" % generated_lib_header,
        # The module name here needs to match the target name,
        # as this is what pybind_extension uses for the name
        # exposed to `import`
        "--pybind-module-name=%s" % pybind_target,
    ]
    heir_translate(
        name = pybind_codegen_target,
        src = generated_heir_opt_name,
        passes = pybind_flags,
        generated_filename = generated_pybind_cc_name,
    )
    pybind_extension(
        name = pybind_target,
        srcs = [generated_pybind_cc_name],
        deps = [
            pybind_codegen_target,
            "@openfhe//:pke",
            cc_lib_target,
        ],
        tags = tags,
        data = data,
        **kwargs
    )
