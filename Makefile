.PHONY: all test clean

all: 
	gcc src/*.c -std=c99 -o nix-c-example -Wall -Wextra -Werror -fsanitize=address -g3 -lm -lcurl
clean: 
	rm nix-c-example
