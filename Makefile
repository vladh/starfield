.POSIX:
.SUFFIXES:

LIBS=-lc -lSDL2_image -lSDL2 -lGL

demo:
	hare build $(LIBS) cmd/demo

run:
	hare run $(LIBS) cmd/demo

.PHONY: demo run
