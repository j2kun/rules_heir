load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//heir:extensions.bzl", "make_nightly_url")

def _urls_test_impl(ctx):
    env = unittest.begin(ctx)

    # Test case 1: Standard release URL
    url = "https://github.com/google/heir/releases/download/v2026.06.01/heir-opt-manylinux_2_28_x86_64"
    expected = "https://github.com/google/heir/releases/download/nightly/heir-opt-manylinux_2_28_x86_64"
    asserts.equals(env, expected, make_nightly_url(url))

    # Test case 2: Another platform
    url = "https://github.com/google/heir/releases/download/v2026.06.01/heir-translate-macosx_11_0_arm64"
    expected = "https://github.com/google/heir/releases/download/nightly/heir-translate-macosx_11_0_arm64"
    asserts.equals(env, expected, make_nightly_url(url))

    return unittest.end(env)

urls_test = unittest.make(_urls_test_impl)

def test_urls():
    unittest.suite(
        "urls_tests",
        urls_test,
    )
