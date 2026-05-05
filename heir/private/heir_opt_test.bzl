load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")
load("//heir:heir_opt.bzl", "heir_opt")

def _heir_opt_test_impl(ctx):
    env = analysistest.begin(ctx)
    actions = analysistest.target_actions(env)

    # Assert that one action was registered
    asserts.equals(env, 1, len(actions), "Expected exactly 1 action")

    # Assert that the mnemonic is "HeirOpt"
    asserts.equals(env, "HeirOpt", actions[0].mnemonic, "Mnemonic did not match")

    # Assert that the output file is correct
    action_outputs = actions[0].outputs.to_list()
    asserts.equals(env, 1, len(action_outputs), "Expected exactly 1 output file")
    asserts.equals(env, "test_output.mlir", action_outputs[0].basename, "Output filename did not match")

    return analysistest.end(env)

heir_opt_test = analysistest.make(_heir_opt_test_impl)

def test_heir_opt():
    heir_opt(
        name = "test_target",
        src = "dummy.mlir",
        passes = ["--canonicalize"],
        generated_filename = "test_output.mlir",
        tags = ["manual"],
    )

    heir_opt_test(
        name = "heir_opt_analysis_test",
        target_under_test = ":test_target",
    )
