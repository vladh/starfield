.POSIX:
.SUFFIXES:

LIBS=-lc -lSDL2_image -lSDL2 -lEGL

demo:
	LD_LIBRARY_PATH=/usr/lib:${LD_LIBRARY_PATH} hare build $(LIBS) cmd/demo

run:
	LD_LIBRARY_PATH=/usr/lib:${LD_LIBRARY_PATH} hare run $(LIBS) cmd/demo

run-nocache:
	@ # Bug https://todo.sr.ht/~sircmpwn/hare/569
	rm -rf \
		${HOME}/.cache/hare/common \
		${HOME}/.cache/hare/graphics \
		${HOME}/.cache/hare/engine
	LD_LIBRARY_PATH=/usr/lib:${LD_LIBRARY_PATH} hare run $(LIBS) cmd/demo

.PHONY: demo run
