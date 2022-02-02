# starfield

This is the Windows 3.1 “starfield” screensaver, implemented in [Hare].
It uses [hare-sdl2], [hare-gl] and [hare-glm].

[Hare]: https://harelang.org
[hare-sdl2]: https://git.sr.ht/~sircmpwn/hare-sdl2
[hare-gl]: https://git.sr.ht/~vladh/hare-gl
[hare-glm]: https://git.sr.ht/~vladh/hare-glm

## Usage

* Make sure to clone with submodules (`git clone --recurse-submodules git@git.sr.ht:~vladh/starfield`)
* Install `libsdl2` and `libsdl2-image`
* Run `make run` to run the demo

## Developing

If you'd like to work on the code, use `make run-nocache`, adjusting the
path in the `Makefile` if you have a special `HARECACHE` set. This is necessary
until [bug 569](https://todo.sr.ht/~sircmpwn/hare/569) is fixed.
