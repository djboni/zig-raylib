const std = @import("std");
const r = @cImport({
    @cInclude("raylib.h");
    @cInclude("raygui.h");
});

pub fn main() !void {
    r.InitWindow(1920 / 2, 1080 / 2, "raygui - controls test suite");
    defer r.CloseWindow();
    r.SetTargetFPS(60);
    r.GuiEnableTooltip();

    var state = struct {
        guiToggleActive: bool = false,
        guiToggleGroupActive: c_int = 0,
        guiToggleSliderActive: c_int = 0,
        guiCheckBoxActive: bool = false,
        guiComboBoxActive: c_int = 0,
        guiDropDownBoxActive: c_int = 0,
        guiDropDownBoxEdit: bool = false,
        guiSpinnerValue: c_int = 0,
        guiSpinnerEdit: bool = false,
        guiValueBoxValue: c_int = 0,
        guiValueBoxEdit: bool = false,
        guiValueBoxFloatValue: f32 = 0.0,
        guiValueBoxFloatEdit: bool = false,
        guiValueBoxFloatText: [128]u8 = undefined,
        guiTextBoxText: [128]u8 = undefined,
        guiTextBoxEdit: bool = false,
        guiSliderValue: f32 = 0.0,
        guiSliderBarValue: f32 = 0.0,
        guiProgressBarValue: f32 = 90.0,
        guiGridMouseCell: r.Vector2 = undefined,
        guiListViewScrollIndex: c_int = 0,
        guiListViewScrollActive: c_int = 0,
        guiMessageBoxLastClick: c_int = -1,
        guiTextInputBoxLastClick: c_int = -1,
        guiTextInputBoxLastText: [128]u8 = undefined,
        guiTextInputBoxLastSecret: bool = false,
        guiTabBarActive: c_int = 0,
    }{};
    std.mem.copyForwards(u8, &state.guiValueBoxFloatText, "float\x00");
    std.mem.copyForwards(u8, &state.guiTextInputBoxLastText, "GuiTextBox\x00");
    std.mem.copyForwards(u8, &state.guiTextBoxText, "GuiTextInputBox\x00");

    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        defer r.EndDrawing();
        r.ClearBackground(r.GetColor(@bitCast(r.GuiGetStyle(r.DEFAULT, r.BACKGROUND_COLOR))));

        var countHeight: u32 = 0;
        const deltaHeight: u32 = 30;
        var countWidth: u32 = 0;
        const deltaWidth: u32 = 120;

        // Label
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiLabel";
            r.GuiSetTooltip("GuiLabel");
            // No tool tip
            const ret = r.GuiLabel(bounds, text);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 1;
        }

        // GuiButton
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiButton";
            r.GuiSetTooltip("GuiButton");
            const ret = r.GuiButton(bounds, text);
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 2;
        }

        // GuiLabelButton
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiLabelButton";
            r.GuiSetTooltip("GuiLabelButton");
            // No tool tip
            const ret = r.GuiLabelButton(bounds, text);
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 1;
        }

        // GuiToggle
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiToggle";
            r.GuiSetTooltip("GuiToggle");
            const ret = r.GuiToggle(bounds, text, &state.guiToggleActive);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 2;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{}", .{state.guiToggleActive}) catch "OOB");
            countHeight += 1;
        }

        // GuiToggleGroup
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120 / 3, .height = 30 };
            const text = "#191#GuiToggleGroup0;Option1;Option2";
            r.GuiSetTooltip("GuiToggleGroup");
            const ret = r.GuiToggleGroup(bounds, text, &state.guiToggleGroupActive);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 2;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{}", .{state.guiToggleGroupActive}) catch "OOB");
            countHeight += 1;
        }

        // GuiToggleSlider
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiToggleSlider0;Option1;Option2";
            r.GuiSetTooltip("GuiToggleSlider");
            // No tool tip
            const ret = r.GuiToggleSlider(bounds, text, &state.guiToggleSliderActive);
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 1;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{}", .{state.guiToggleSliderActive}) catch "OOB");
            countHeight += 1;
        }

        // GuiCheckBox
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth + 7), .y = @floatFromInt(countHeight * deltaHeight + 7), .width = 15, .height = 15 };
            const text = "#191#GuiCheckBox";
            r.GuiSetTooltip("GuiCheckBox");
            // No tool tip
            const ret = r.GuiCheckBox(bounds, text, &state.guiCheckBoxActive);
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 1;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{}", .{state.guiCheckBoxActive}) catch "OOB");
            countHeight += 1;
        }

        // GuiComboBox
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiComboBox;Option1;Option2";
            r.GuiSetTooltip("GuiComboBox");
            const ret = r.GuiComboBox(bounds, text, &state.guiComboBoxActive);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 1;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{}", .{state.guiComboBoxActive}) catch "OOB");
            countHeight += 1;
        }

        countWidth += 2;
        countHeight = 0;

        // GuiDropdownBox
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiDropdownBox;Option1;Option2";
            r.GuiSetTooltip("GuiDropdownBox");
            // No tool tip
            const ret = r.GuiDropdownBox(bounds, text, &state.guiDropDownBoxActive, state.guiDropDownBoxEdit);
            if (ret == 1)
                state.guiDropDownBoxEdit = !state.guiDropDownBoxEdit;
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 5;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{} {}", .{ state.guiDropDownBoxActive, state.guiDropDownBoxEdit }) catch "OOB");
            countHeight += 1;
        }

        // GuiSpinner
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiSpinner";
            r.GuiSetTooltip("GuiSpinner");
            const ret = r.GuiSpinner(bounds, text, &state.guiSpinnerValue, 0, 5, state.guiSpinnerEdit);
            if (ret == 1)
                state.guiSpinnerEdit = !state.guiSpinnerEdit;
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 2;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{} {}", .{ state.guiSpinnerEdit, state.guiSpinnerValue }) catch "OOB");
            countHeight += 1;
        }

        // GuiValueBox
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiValueBox";
            r.GuiSetTooltip("GuiValueBox");
            // No tool tip
            const ret = r.GuiValueBox(bounds, text, &state.guiValueBoxValue, 0, 5, state.guiValueBoxEdit);
            if (ret == 1)
                state.guiValueBoxEdit = !state.guiValueBoxEdit;
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 1;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{} {}", .{ state.guiValueBoxEdit, state.guiValueBoxValue }) catch "OOB");
            countHeight += 1;
        }

        // GuiValueBoxFloat
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiValueBoxFloat";
            r.GuiSetTooltip("GuiValueBoxFloat");
            // No tool tip
            const ret = r.GuiValueBoxFloat(bounds, text, &state.guiValueBoxFloatText, &state.guiValueBoxFloatValue, state.guiValueBoxFloatEdit);
            if (ret == 1)
                state.guiValueBoxFloatEdit = !state.guiValueBoxFloatEdit;
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 1;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{} {d}", .{ state.guiValueBoxFloatEdit, state.guiValueBoxFloatValue }) catch "OOB");
            countHeight += 1;
        }

        // GuiTextBox
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            r.GuiSetTooltip("GuiTextBox");
            const ret = r.GuiTextBox(bounds, &state.guiTextBoxText, state.guiTextBoxText.len, state.guiTextBoxEdit);
            if (ret == 1)
                state.guiTextBoxEdit = !state.guiTextBoxEdit;
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 2;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{} {s}", .{ state.guiTextBoxEdit, std.mem.span(@as([*c]u8, @ptrCast(&state.guiTextBoxText))) }) catch "OOB");
            countHeight += 1;
        }

        countWidth += 2;
        countHeight = 0;

        // GuiSlider
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const textLeft = "#191#GuiSlider";
            const textRight = "#191#Right";
            r.GuiSetTooltip("GuiSlider");
            // No tool tip
            const ret = r.GuiSlider(bounds, textLeft, textRight, &state.guiSliderValue, -5.0, 5.0);
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 1;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{d}", .{state.guiSliderValue}) catch "OOB");
            countHeight += 1;
        }

        // GuiSliderBar
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const textLeft = "#191#GuiSliderBar";
            const textRight = "#191#Right";
            r.GuiSetTooltip("GuiSliderBar");
            // No tool tip
            const ret = r.GuiSliderBar(bounds, textLeft, textRight, &state.guiSliderBarValue, -5.0, 5.0);
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 1;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{d}", .{state.guiSliderBarValue}) catch "OOB");
            countHeight += 1;
        }

        // GuiProgressBar
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const textLeft = "#191#GuiProgressBar";
            const textRight = "#191#Right";
            r.GuiSetTooltip("GuiProgressBar");
            // No tool tip
            const ret = r.GuiProgressBar(bounds, textLeft, textRight, &state.guiProgressBarValue, 0.0, 100.0);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 1;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{d} %", .{state.guiProgressBarValue}) catch "OOB");
            countHeight += 1;
        }

        // GuiStatusBar
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiStatusBar";
            r.GuiSetTooltip("GuiStatusBar");
            // No tool tip
            const ret = r.GuiStatusBar(bounds, text);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 1;
        }

        // GuiDummyRec
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            const text = "#191#GuiDummyRec";
            r.GuiSetTooltip("GuiDummyRec");
            // No tool tip
            const ret = r.GuiDummyRec(bounds, text);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 1;
        }

        // GuiGrid
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 90 };
            const text = "#191#GuiGrid";
            r.GuiSetTooltip("GuiGrid");
            // No tool tip
            const ret = r.GuiGrid(bounds, text, 20.0, 2, &state.guiGridMouseCell);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 3;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "x={d} y={d}", .{ state.guiGridMouseCell.x, state.guiGridMouseCell.y }) catch "OOB");
            countHeight += 1;
        }

        // GuiListView
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 64 };
            const text = "#191#GuiListView;Option1;Option2;Option3;Option4";
            r.GuiSetTooltip("GuiListView");
            // No tool tip
            const ret = r.GuiListView(bounds, text, &state.guiListViewScrollIndex, &state.guiListViewScrollActive);
            std.debug.assert(ret == 0);
            // Returns 1 when clicked, 0 otherwise
            countHeight += 2;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{} {}", .{ state.guiListViewScrollIndex, state.guiListViewScrollActive }) catch "OOB");
            countHeight += 1;
        }

        // GuiTabBar
        {
            const bounds = r.Rectangle{ .x = @floatFromInt((countWidth - 1) * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 30, .height = 30 };
            var text = [_][*c]const u8{
                "#191#Tab0", "Tab1", "Tab2",
            };
            r.GuiSetTooltip("GuiTabBar");
            const ret = r.GuiTabBar(bounds, @ptrCast(&text), text.len, &state.guiTabBarActive);
            std.debug.assert(ret >= -1 and ret <= 2);
            // Returns -1 when no tab has to close
            // number >=0 when a tab was closed
            countHeight += 1;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{}", .{state.guiTabBarActive}) catch "OOB");
            countHeight += 1;
        }

        countWidth += 2;
        countHeight = 0;

        // GuiMessageBox
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 240, .height = 90 };
            const title = "#191#GuiMessageBox - Title";
            const message = "#191#GuiMessageBox - Message";
            const buttons = "#191#OK;Cancel;Other";
            r.GuiSetTooltip("GuiMessageBox");
            const ret = r.GuiMessageBox(bounds, title, message, buttons);
            if (ret != -1)
                state.guiMessageBoxLastClick = ret;
            std.debug.assert(ret >= -1 and ret <= 3);
            // Returns -1 when nothing is clicked
            // 0 when the close button (x) clicked
            // number >=1 when one of the options was clicked
            countHeight += 3;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{}", .{state.guiMessageBoxLastClick}) catch "OOB");
            countHeight += 1;
        }

        // GuiTextInputBox
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 240, .height = 120 };
            const title = "#191#GuiTextInputBox - Title";
            const message = "#191#GuiTextInputBox - Message";
            const buttons = "#191#OK;Cancel;Other";
            r.GuiSetTooltip("GuiTextInputBox");
            const ret = r.GuiTextInputBox(bounds, title, message, buttons, &state.guiTextInputBoxLastText, state.guiTextInputBoxLastText.len, &state.guiTextInputBoxLastSecret);
            // Pass null instead of a pointer on secretViewActive to have no secret
            if (ret != -1)
                state.guiTextInputBoxLastClick = ret;
            std.debug.assert(ret >= -1 and ret <= 3);
            // Returns -1 when nothing is clicked
            // 0 when the close button (x) clicked
            // number >=1 when one of the options was clicked
            countHeight += 4;

            const labelBounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 120, .height = 30 };
            var buff: [128]u8 = undefined;
            _ = r.GuiLabel(labelBounds, std.fmt.bufPrintZ(&buff, "{} {} {s}", .{ state.guiTextInputBoxLastClick, state.guiTextInputBoxLastSecret, std.mem.span(@as([*c]const u8, &state.guiTextInputBoxLastText)) }) catch "OOB");
            countHeight += 1;
        }

        // GuiWindowBox
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 240, .height = 30 };
            const title = "#191#GuiWindowBox";
            r.GuiSetTooltip("GuiWindowBox");
            const ret = r.GuiWindowBox(bounds, title);
            std.debug.assert(ret == 0 or ret == 1);
            // Returns 1 when clicked on close, 0 otherwise
            countHeight += 2;
        }

        // GuiGroupBox
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 240, .height = 30 };
            const text = "#191#GuiGroupBox";
            r.GuiSetTooltip("GuiGroupBox");
            // No tool tip
            const ret = r.GuiGroupBox(bounds, text);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 1;
        }

        // GuiLine
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 240, .height = 30 };
            const text = "#191#GuiLine";
            r.GuiSetTooltip("GuiLine");
            // No tool tip
            const ret = r.GuiLine(bounds, text);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 1;
        }

        // GuiPanel
        {
            const bounds = r.Rectangle{ .x = @floatFromInt(countWidth * deltaWidth), .y = @floatFromInt(countHeight * deltaHeight), .width = 240, .height = 30 };
            const text = "#191#GuiPanel";
            r.GuiSetTooltip("GuiPanel");
            // No tool tip
            const ret = r.GuiPanel(bounds, text);
            std.debug.assert(ret == 0);
            // Returns 0
            countHeight += 2;
        }
    }
}
