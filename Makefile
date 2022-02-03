.POSIX:
.SUFFIXES:

LIBS=-lc -lSDL2_image -lSDL2 -lEGL
VARS=LD_LIBRARY_PATH=/usr/lib:${LD_LIBRARY_PATH} \
	HAREPATH=vendor/hare-sdl2:vendor/hare-glm:vendor/gl:${HAREPATH}

starfield:
	$(VARS) hare build $(LIBS) cmd/starfield

run:
	$(VARS) hare run $(LIBS) cmd/starfield

run-nocache:
	@ # Bug https://todo.sr.ht/~sircmpwn/hare/569
	rm -rf \
		${HOME}/.cache/hare/common \
		${HOME}/.cache/hare/graphics \
		${HOME}/.cache/hare/engine
	$(VARS) hare run $(LIBS) cmd/starfield

.PHONY: starfield run run-nocache
