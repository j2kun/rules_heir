load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")
load("//heir:heir_opt.bzl", "heir_opt")

def _heir_opt_default_test_impl(ctx):
    env = analysistest.begin(ctx)
    actions = analysistest.target_actions(env)

    # Assert that one action was registered
    asserts.equals(env, 1, len(actions), "Expected exactly 1 action")

    # Assert that the mnemonic is "HeirOpt"
    asserts.equals(env, "HeirOpt", actions[0].mnemonic, "Mnemonic did not match")

    # Assert that the output files are correct (default includes generated file and default resources dir)
    action_outputs = actions[0].outputs.to_list()
    asserts.equals(env, 2, len(action_outputs), "Expected exactly 2 output files")
    output_basenames = [out.basename for out in action_outputs]
    asserts.true(env, "test_output.mlir" in output_basenames, "Expected test_output.mlir in outputs")
    asserts.true(env, "test_target_default_resources" in output_basenames, "Expected test_target_default_resources in outputs")

    return analysistest.end(env)

def _heir_opt_no_ext_test_impl(ctx):
    env = analysistest.begin(ctx)
    actions = analysistest.target_actions(env)

    # Assert that one action was registered
    asserts.equals(env, 1, len(actions), "Expected exactly 1 action")

    # Assert that the mnemonic is "HeirOpt"
    asserts.equals(env, "HeirOpt", actions[0].mnemonic, "Mnemonic did not match")

    # Assert that only the output mlir file is produced when externalize_constants is False
    action_outputs = actions[0].outputs.to_list()
    asserts.equals(env, 1, len(action_outputs), "Expected exactly 1 output file")
    asserts.equals(env, "test_output_no_ext.mlir", action_outputs[0].basename, "Output filename did not match")

    return analysistest.end(env)

def _heir_opt_custom_dir_test_impl(ctx):
    env = analysistest.begin(ctx)
    actions = analysistest.target_actions(env)

    # Assert that one action was registered
    asserts.equals(env, 1, len(actions), "Expected exactly 1 action")

    # Assert that the mnemonic is "HeirOpt"
    asserts.equals(env, "HeirOpt", actions[0].mnemonic, "Mnemonic did not match")

    # Assert that custom resources dir is produced
    action_outputs = actions[0].outputs.to_list()
    asserts.equals(env, 2, len(action_outputs), "Expected exactly 2 output files")
    output_basenames = [out.basename for out in action_outputs]
    asserts.true(env, "test_output_custom.mlir" in output_basenames, "Expected test_output_custom.mlir in outputs")
    asserts.true(env, "custom_resources" in output_basenames, "Expected custom_resources in outputs")

    return analysistest.end(env)

heir_opt_default_test = analysistest.make(_heir_opt_default_test_impl)
heir_opt_no_ext_test = analysistest.make(_heir_opt_no_ext_test_impl)
heir_opt_custom_dir_test = analysistest.make(_heir_opt_custom_dir_test_impl)

def test_heir_opt():
    heir_opt(
        name = "test_target_default",
        src = "dummy.mlir",
        passes = ["--canonicalize"],
        generated_filename = "test_output.mlir",
        tags = ["manual"],
    )

    heir_opt_default_test(
        name = "heir_opt_default_analysis_test",
        target_under_test = ":test_target_default",
    )

    heir_opt(
        name = "test_target_no_ext",
        src = "dummy.mlir",
        passes = ["--canonicalize"],
        generated_filename = "test_output_no_ext.mlir",
        externalize_constants = False,
        tags = ["manual"],
    )

    heir_opt_no_ext_test(
        name = "heir_opt_no_ext_analysis_test",
        target_under_test = ":test_target_no_ext",
    )

    heir_opt(
        name = "test_target_custom_dir",
        src = "dummy.mlir",
        passes = ["--canonicalize"],
        generated_filename = "test_output_custom.mlir",
        ext_const_output_dir = "custom_resources",
        tags = ["manual"],
    )

    heir_opt_custom_dir_test(
        name = "heir_opt_custom_dir_analysis_test",
        target_under_test = ":test_target_custom_dir",
    )
