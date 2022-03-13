#include <raylib.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>

const int screenWidth = 640;
const int screenHeight = 480;
char *quote = "I must not fear.\nFear is the mind killer.";
const int FONT_SIZE = 40;
const int WMODIFIER = screenWidth / FONT_SIZE;

void
init() 
{
    SetTraceLogLevel(LOG_NONE);

    InitWindow(screenWidth, screenHeight, "T P R");

    SetWindowState(FLAG_WINDOW_RESIZABLE);

/*    InitAudioDevice(); */
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


    char* user_input = malloc((sizeof(char) * quote_len));
    memset(user_input, ' ', quote_len + 1);
    user_input[quote_len+1] = '\0';

    char* user_input_false = malloc((sizeof(char) * quote_len));
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

        /* Start all over again */

        show_end_msg = letterCount == quote_len - 1;

        BeginDrawing();

            ClearBackground((Color){0x11, 0x11, 0x11, 0xff});

            if (show_end_msg) {
                DrawText("Gimme more", (screenWidth ) - (TextLength(quote) * FONT_SIZE), 10, FONT_SIZE, YELLOW);
            }


            /* Quote Text */
            DrawText(quote, 40, screenHeight / 2.0, FONT_SIZE, GRAY);

            /* Colored False Text */
            DrawText(user_input_false, 40, screenHeight / 2.0, FONT_SIZE, RED);

            /* Colored True Text */
            DrawText(user_input, 40, screenHeight / 2.0, FONT_SIZE, BLUE);

        EndDrawing();
    }

    /* Clean */

    free(user_input);

    CloseAudioDevice();

    CloseAudioDevice();

    CloseWindow();
}
