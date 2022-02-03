use math;

use glm;
use glm::{ v3, v4, m4 };
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

	state.t += 0.01666;

	const eye_x = math::sinf64(state.t / 4.0) * 6.0;
	const eye_z = math::cosf64(state.t / 4.0) * 6.0;
	state.graphics.view = glm::lookat(
		&glm::v3_new(eye_x, 4.0, eye_z),
		&glm::v3_new(0.0, 0.0, 0.0),
		&glm::v3_new(0.0, 1.0, 0.0));

	state.engine.rotation += 1.0;
};
