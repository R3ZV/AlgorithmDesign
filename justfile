CC := "g++"
FLAGS := "-std=c++17 -Wall -Wextra"

test:
    @mkdir -p bin
    @{{CC}} {{FLAGS}} main.cpp -o ./bin/main
    @./bin/main < input

run: build
    @./bin/main < input

build:
    @mkdir -p bin

    @{{CC}} {{FLAGS}} main.cpp src/*.cpp -o ./bin/main

clean:
    @rm -r bin || true
