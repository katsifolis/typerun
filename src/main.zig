const ray = @cImport({
    @cInclude("raylib.h");
});

const std = @import("std");
const mem = std.mem;
const Allocator = std.mem.Allocator;

const screenWidth = 800;
const screenHeight = 600;
const quote = "Fear is the mind killer.";
const FONT_SIZE = 20;
const textBox: ray.Rectangle = .{ .x = screenWidth / 2.0 - 100.0, .y = 400, .width = 230, .height = 25 };
const quoteBox: ray.Rectangle = .{ .x = 10, .y = 10, .width = screenWidth - 20.0, .height = 50 };

pub fn main() anyerror!void {
    var buffer: [1000]u8 = undefined;
    const allocator = &std.heap.FixedBufferAllocator.init(&buffer).allocator;
    var words = std.ArrayList([]const u8).init(allocator);
    var quoteSplit = mem.split(quote, " ");
    std.log.info("type of quoteSPlit {s}", .{@TypeOf(quoteSplit)});

    while (quoteSplit.next()) |value| {
        try words.append(value[0..]);
    }

    for (words.items) |item| {
        std.log.info("The value is {s}", .{item});
    }

    // For some reason c pointer arithmetic results in
    // undefined behavior
    //    var c_p: [*c]c_int = 0;
    //    var a = ray.TextSplit(quote, ' ', c_p);
    //    std.log.info("The type of split is {}.", .{@TypeOf(a)});

    var letterCount: usize = 0;
    var name_array = [1:0]u8{' '} ** 16; // 16 array
    var name = name_array[0..name_array.len];
    var key: u16 = undefined;
    //std.log.info("The type of name_array is {}.", .{@TypeOf(name_array)});
    //std.log.info("The type of name is {}.", .{@TypeOf(name)});

    ray.InitWindow(screenWidth, screenHeight, "T P R");
    defer ray.CloseWindow();

    ray.SetTargetFPS(30);

    while (!ray.WindowShouldClose()) {
        key = @intCast(u16, ray.GetKeyPressed());

        while (key > 0) {
            // NOTE: Only allow keys in range [32..125]
            if ((key >= 32) and (key <= 125) and (letterCount < 16)) {
                name[letterCount] = if (ray.IsKeyDown(ray.KEY_LEFT_SHIFT)) @intCast(u8, key) else @intCast(u8, key) | 0x20;
                std.log.info("The key {}\n", .{name[letterCount]});
                letterCount += 1;
            }

            key = @intCast(u16, ray.GetKeyPressed());
        }

        if (ray.IsKeyPressed(ray.KEY_BACKSPACE)) {
            if (letterCount < 1) {
                letterCount = 0;
            } else {
                letterCount -= 1;
            }
            name[letterCount] = ' ';
        }

        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);

        ray.DrawRectangleRec(textBox, .{ .r = 0x11, .g = 0x11, .b = 0x11, .a = 0xff });
        ray.DrawText(name_array[0..], textBox.x + 5, textBox.y + 4, FONT_SIZE, ray.MAROON);

        ray.DrawRectangleRec(quoteBox, .{ .r = 0x33, .g = 0x33, .b = 0x33, .a = 0xff });
        ray.DrawText(quote, quoteBox.x + 5, quoteBox.y + 4, FONT_SIZE * 2, ray.BLUE);
    }
}
