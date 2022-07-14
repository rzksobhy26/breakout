UNAME_S = $(shell uname -s)

CC = gcc
CFLAGS = -Wall -Wextra -pedantic -std=c11 -ggdb
CFLAGS += -Ilib/glad/include/ -Ilib/glfw/include/
LDFLAGS = lib/glad/src/glad.o lib/glfw/src/libglfw3.a -lm

# GLFW required frameworks on OSX
ifeq ($(UNAME_S), Darwin)
	LDFLAGS += -framework OpenGL -framework IOKit -framework CoreVideo -framework Cocoa
endif

ifeq ($(UNAME_S), Linux)
	LDFLAGS += -lGL -lX11 -lGLU -lOpenGL -ldl -lpthread
endif

SRC = $(wildcard src/*.c) $(wildcard src/**/*.c) $(wildcard src/**/**/*.c)
OBJ = $(SRC:.c=.o)
BIN = bin

.PHONY: all clean

all: $(BIN) libs $(BIN)/output

$(BIN):
	mkdir -p $(BIN)

libs: lib/glfw/src/libglfw3.a lib/glad/src/glad.o

lib/glfw/src/libglfw3.a:
	mkdir -p lib/glfw/build
	cd lib/glfw/build && cmake .. && make

lib/glad/src/glad.o: lib/glad/src/glad.c
	$(CC) -o $(@) -Ilib/glad/include -c $(<)

$(BIN)/output: $(OBJ)
	$(CC) -o $(@) $(^) $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -o $(@) -c $(<)

run: all
	./$(BIN)/output

clean:
	rm -rf $(BIN) $(OBJ)
