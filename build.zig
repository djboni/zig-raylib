const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const run_step = b.step("run", "Run the app");
    const test_step = b.step("test", "Run unit tests");

    ///////////////////////////////////////////////////////////////////////////
    // Raylib Library
    ///////////////////////////////////////////////////////////////////////////

    // NOTE: Bring the external library as a dependency
    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
        // NOTE: This is how to set options for the external library
        .shared = false,
        //.linux_display_backend = .X11,
    });
    const raylib = raylib_dep.artifact("raylib");

    ///////////////////////////////////////////////////////////////////////////
    // CIM Executable
    ///////////////////////////////////////////////////////////////////////////

    // Build the executable
    const exe = b.addExecutable(.{
        .name = "zig-raylib",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    // NOTE: Link the external library to the executable
    exe.linkLibrary(raylib);
    // NOTE: Add C files to the build
    exe.addCSourceFiles(.{ .files = &.{"./src/raygui.c"}, .flags = &.{} });
    exe.addIncludePath(b.path("./dep/raygui/src/"));
    // NOTE: When adding C files or libraries you also need to link with libc
    exe.linkLibC();

    // Run the executable
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args|
        run_cmd.addArgs(args);
    run_step.dependOn(&run_cmd.step);

    // Build and run the executable tests
    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    test_step.dependOn(&run_exe_unit_tests.step);
}
