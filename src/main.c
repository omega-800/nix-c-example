#include "raylib.h"
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  InitWindow(1600, 900, "raylib");
  SetTargetFPS(30);

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(c);
    DrawText("Hello World!", 100, 100, 40, MAROON);
    EndDrawing();
  }

  CloseWindow();
  return 0;
}
