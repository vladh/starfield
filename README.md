# starfield

This is the Windows 3.1 “starfield” screensaver,
except the stars are rabbits. :)

It's implemented in [Hare] and uses [hare-sdl2], [hare-gl] and [hare-glm].

[Hare]: https://harelang.org
[hare-sdl2]: https://git.sr.ht/~sircmpwn/hare-sdl2
[hare-gl]: https://git.sr.ht/~vladh/hare-gl
[hare-glm]: https://git.sr.ht/~vladh/hare-glm

## Usage

* Make sure to clone with submodules (`git clone --recurse-submodules git@git.sr.ht:~vladh/starfield`)
* Install `libsdl2` and `libsdl2-image`
* Run `make run` to run the demo

## Developing

Please note that `make run` will delete some cache directories in
`~/.cache/hare/` due to [bug 569](https://todo.sr.ht/~sircmpwn/hare/569).
You may want to adjust the `Makefile` if you have a special `HARECACHE` set.
