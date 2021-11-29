// TODO
// 1. Size of space  is not the same width as the fonts
//

const ray = @cImport({
    @cInclude("raylib.h");
});

const std = @import("std");
const mem = std.mem;
const Allocator = std.mem.Allocator;

const screenWidth = 800;
const screenHeight = 200;
var quote = "Fear is the mind killer. Don't you see it's this";
var wpm: f64 = 0;
const FONT_SIZE: u32 = 20;
const WMODIFIER = screenWidth / FONT_SIZE;

const Character = struct { character: []u8, hi: bool };

pub fn main() anyerror!void {
    ray.SetTraceLogLevel(ray.LOG_NONE);
    const FONT = ray.LoadFont("mono.ttf");
    var buffer: [1000]u8 = undefined;
    var word_count: usize = 0;
    const allocator = &std.heap.FixedBufferAllocator.init(&buffer).allocator;
    var words = std.ArrayList([]const u8).init(allocator);
    var quoteSplit = mem.split(quote, " ");

    while (quoteSplit.next()) |value| {
        try words.append(value[0..]);
    }

    var letterCount: usize = 0;
    var false_key: usize = 0;
    var user_input_array = [1:0]u8{' '} ** quote.len; // Len of the array
    var user_input = user_input_array[0..user_input_array.len];
    var user_input_false_array = [1:0]u8{' '} ** quote.len; // Len of the array
    var user_input_false = user_input_false_array[0..user_input_false_array.len];
    var key: u16 = undefined;
    var is_same: bool = false;

    ray.InitWindow(screenWidth, screenHeight, "T P R");
    defer ray.CloseWindow();

    ray.SetTargetFPS(20);

    while (!ray.WindowShouldClose()) {
        key = @intCast(u16, ray.GetKeyPressed());

        while (key > 0) {
            // NOTE: Only allow keys in range [32..125]
            if ((key >= 32) and (key <= 125) and letterCount < quote.len) {
                user_input[letterCount] = if (ray.IsKeyDown(ray.KEY_LEFT_SHIFT))
                    @intCast(u8, key)
                else
                    @intCast(u8, key) | 0x20;
                //                std.log.info(" user input: {} quote input: {}", .{ user_input[letterCount], quote[letterCount] });
                wpm = (1 / 5) * ray.GetTime();
                is_same = if (user_input[letterCount] == quote[letterCount]) true else false;
                false_key = letterCount;
                letterCount += 1;
            }

            if (key == ray.KEY_BACKSPACE) {
                if (letterCount < 1) {
                    letterCount = 0;
                } else {
                    letterCount -= 1;
                }
                user_input[letterCount] = ' ';
                user_input_false[false_key] = ' ';
            }

            key = @intCast(u16, ray.GetKeyPressed());
        }

        if (letterCount == quote.len) {
            // Change the string
            // quote = "Main is the fuck killer";
            mem.set(u8, user_input, ' ');
            letterCount = 0;
        }
        if (!is_same and letterCount > 0 and key != ray.KEY_BACKSPACE) {
            user_input_false[false_key] = quote[false_key];
            user_input[false_key] = ' ';
            // Colored False Text
            letterCount = 0;
            mem.set(u8, user_input, ' ');
        }

        // Drawing
        ray.BeginDrawing();
        defer ray.EndDrawing();

        ray.ClearBackground(ray.BLACK);
        // Quote Text
        ray.DrawText(
            quote,
            40,
            screenHeight / 2.0,
            FONT_SIZE,
            ray.GRAY,
        );

        // Colored True Text
        ray.DrawText(
            user_input,
            40,
            screenHeight / 2.0,
            FONT_SIZE,
            ray.BLUE,
        );

        //        ray.DrawText(
        //            wpm,
        //            10,
        //            10,
        //            FONT_SIZE,
        //            ray.RED,
        //        );
    }
}
