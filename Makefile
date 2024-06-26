.POSIX:
.SUFFIXES:

LIBS=-lc -lSDL2 -lEGL
VARS=LD_LIBRARY_PATH=/usr/lib:${LD_LIBRARY_PATH} \
	HAREPATH=vendor/hare-sdl2:vendor/hare-glm:vendor/gl:${HAREPATH}

starfield:
	$(VARS) hare build $(LIBS) cmd/starfield

run:
	@ # Bug https://todo.sr.ht/~sircmpwn/hare/569
	rm -rf \
		${HOME}/.cache/hare/common \
		${HOME}/.cache/hare/graphics \
		${HOME}/.cache/hare/engine
	$(VARS) hare run $(LIBS) cmd/starfield

.PHONY: starfield run
