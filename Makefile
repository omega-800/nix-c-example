.PHONY: all test clean

all: 
	$(CC) src/*.c -std=c99 -o nix-raylib-example -Wall -Wextra -Werror -fsanitize=address -g3 -lm $(pkg-config --cflags raylib) -lraylib
clean: 
	rm nix-raylib-example
