# Zig Raylib

Alternative Title: How to add an external library to you Zig project.

by Djones A. Boni

I tried to build [Raylib](https://github.com/raysan5/raylib) with Zig and add
it to a Zig project. It did not go as smooth as I wished.

So I created this project as a reference for me in the future and also for
other people who is struggling to do the same.

With this project we can just clone and `zig build run` our way to a working
Raylib project.

## Versions

- Raylib 5.5
- Zig 0.13.0

## Objective of this Project

Raylib has a pretty good build.zig that allows it to be added as a dependency
and configured with much ease.

Zig is currently in development, changing quite a bit, and it is not well
documented yet, so it was hard to fit all the bits in the right places.

Adding a dependency such as Raylib is easy, once you know
**what functions to call** in your build.zig.

This project's objective is to explain the **what functions to call** part.

## Pain Points (What I Have Learned)

- Add an external library as a dependency on build.zig.zon

  - I added it a subdirectory in my project

    ```zon
    .dependencies = .{
        .raylib = .{ .path = "./dep/raylib/" },
    },
    ```

  - It is also possible to add a link and let Zig download it for you

    ```zon
    .dependencies = .{
        .raylib = .{ .url = "...", .hash = "..." },
    },
    ```

- Bring the external dependency into your build.zig

  ```zig
      const raylib_dep = b.dependency("raylib", .{
          .target = target,
          .optimize = optimize,
          // NOTE: This is how to set options for the external library
          .shared = false,
          //.linux_display_backend = .X11,
      });
      const raylib = raylib_dep.artifact("raylib");
  ```

- Set options for the external dependency (as shown above)

  - I had to enable the option `.linux_display_backend = .X11`

- Link the external library to the executable

  ```zig
    // NOTE: Link the external library to the executable
    exe.linkLibrary(raylib);
    // NOTE: Add C files to the build
    exe.addCSourceFiles(.{ .files = &.{"./src/raygui.c"}, .flags = &.{} });
    exe.addIncludePath(b.path("./dep/raygui/src/"));
    // NOTE: When adding C files or libraries you also need to link with libc
    exe.linkLibC();
  ```

- Adding C files to the build (as shown above)
