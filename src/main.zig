const std = @import("std");
const r = @cImport({
    @cInclude("raylib.h");
    @cInclude("raygui.h");
});

pub fn main() !void {
    r.InitWindow(400, 200, "raygui - controls test suite");
    defer r.CloseWindow();

    r.SetTargetFPS(60);

    var showMessageBox: bool = false;

    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        defer r.EndDrawing();

        r.ClearBackground(r.GetColor(@bitCast(r.GuiGetStyle(r.DEFAULT, r.BACKGROUND_COLOR))));

        if (r.GuiButton(
            r.Rectangle{ .x = 24, .y = 24, .width = 120, .height = 30 },
            "#191#Show Message",
        ) != 0)
            showMessageBox = true;

        if (showMessageBox) {
            const result = r.GuiMessageBox(
                r.Rectangle{ .x = 85, .y = 70, .width = 250, .height = 100 },
                "#191#Message Box",
                "Hi! This is a message!",
                "Nice;Cool",
            );
            if (result >= 0)
                showMessageBox = false;
        }
    }
}
