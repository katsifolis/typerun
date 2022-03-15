#include <raylib.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <math.h>

const int screenWidth = 800;
const int screenHeight = 600;
char *quote = "I must not fear.\nHello there";
const int FONT_SIZE = 60;
const int WMODIFIER = screenWidth / FONT_SIZE;
const char *end_message = "Press [Space] To Continue";
Font font;
Vector2 end_message_vec;

void
init() 
{
    SetTraceLogLevel(LOG_NONE);

    InitWindow(screenWidth, screenHeight, "TypeRun");

    SetWindowState(FLAG_WINDOW_RESIZABLE);
}

int
main() 
{
    init();

    uint8_t letterCount = 0;
    uint8_t false_key = 0;
    int key = 0; /* 32-bit integer */
    bool is_same  = false;
    uint8_t quote_len = strlen(quote) + 1;
    bool show_end_msg = false;
    Font font = LoadFontEx("/usr/share/fonts/ubuntu/UbuntuMono-R.ttf", 60, 0, 0);
    const Vector2 end_message_vec = MeasureTextEx(font, end_message, 40, 1);

    char* user_input = malloc((sizeof(char) * quote_len));
    char* user_input_false = malloc((sizeof(char) * quote_len));
    

    SetTextureFilter(font.texture, TEXTURE_FILTER_BILINEAR);

    memset(user_input, ' ', quote_len + 1);
    user_input[quote_len+1] = '\0';

    memset(user_input_false, ' ', quote_len + 1);
    user_input_false[quote_len+1] = '\0';

    SetTargetFPS(60);

    while (!WindowShouldClose()) {

        key = GetKeyPressed();

        while (key > 0) {
            if ((key >= 32) && (key <= 125) && letterCount < quote_len && !show_end_msg) {

                user_input[letterCount] = !IsKeyUp(KEY_LEFT_SHIFT) ? key : key | 0x20;

                is_same = user_input[letterCount] == quote[letterCount] ? true : false;

                if (!is_same) {
                    user_input_false[letterCount] = quote[letterCount];
                    user_input[letterCount] = ' ';
                } 

                if (key == KEY_SPACE && quote[letterCount] == '\n') {
                    user_input[letterCount] = '\n';
                } else {
                    false_key = letterCount;
                }

                letterCount++;
            }


            switch (key) {
            case KEY_BACKSPACE: 
                if (!show_end_msg) {
                    if (letterCount < 1) {
                        letterCount = 0;
                    } else {
                        letterCount -= 1;
                    }
                    user_input[letterCount] = ' ';
                    user_input_false[letterCount] = ' ';
                }
                break;

            case KEY_SPACE:
                if (show_end_msg) {
                    memset(user_input, ' ', quote_len + 1);
                    letterCount = 0;
                }
                break;

            default: break;
            }
        
            key = GetKeyPressed();
        }

        show_end_msg = letterCount == quote_len - 1;

        BeginDrawing();

            ClearBackground((Color){0x11, 0x11, 0x11, 0xff});

            // Checks for end msg and draws it

            if (show_end_msg) {
                DrawTextEx(font, end_message, (Vector2){(screenWidth / 2.0) - ceil(end_message_vec.x / 2.0), 20}, 40,1 , (Color){0x33, 0x33, 0x33, 0xff});
            }

            DrawTextEx(font, quote, (Vector2){FONT_SIZE, screenHeight / 2.0}, FONT_SIZE, 1, GRAY);

            DrawTextEx(font, user_input_false, (Vector2){FONT_SIZE, screenHeight / 2.0}, FONT_SIZE, 1, RED);

            DrawTextEx(font, user_input, (Vector2){FONT_SIZE, screenHeight / 2.0}, FONT_SIZE, 1, BLUE);

        EndDrawing();
    }

    free(user_input);
    free(user_input_false);

    CloseAudioDevice();

    CloseAudioDevice();

    CloseWindow();
}
