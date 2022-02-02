use sdl2::sdl2;

use common::{ state };

fn process_events(state: *state) (void | sdl2::error) = {
	let ev = sdl2::event { ... };
	for (sdl2::poll_event(&ev)? == 1) {
		switch (ev.event_type) {
		case sdl2::event_type::QUIT =>
			state.should_quit = true;
			return;
			case sdl2::event_type::KEYDOWN =>
			if (ev.key.keysym.sym == sdl2::keycode::ESCAPE) {
				state.should_quit = true;
				return;
			};
		case => void;
		};
	};
};

export fn update(state: *state) (void | sdl2::error) = {
	process_events(state)?;

	state.rotation += 1.0;
};
