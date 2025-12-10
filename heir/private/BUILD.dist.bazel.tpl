package(default_visibility = ["//visibility:public"])

# tools contains executable files that are part of the toolchain.
filegroup(
    name = "runtime",
    srcs = glob(["**/*"]),
)
