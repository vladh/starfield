use fmt;
use math;
use math::random;

use glm;
use glm::{ v3, v4, m4 };
use sdl2;

use common;
use common::{ state };

def STAR_SPEED: f32 = 0.6;
def STAR_Z_MAX: f32 = 10.0;
def STAR_Z_MIN: f32 = -4000.0;
def STAR_XY_EXTENT: f32 = 3000.0;

fn process_events(state: *state) (void | sdl2::error) = {
	let ev = sdl2::event { ... };
	for (sdl2::SDL_PollEvent(&ev)? == 1) {
		switch (ev.event_type) {
		case sdl2::SDL_EventType::QUIT =>
			state.should_quit = true;
			return;
			case sdl2::SDL_EventType::KEYDOWN =>
			if (ev.key.keysym.sym == sdl2::SDL_Keycode::ESCAPE) {
				state.should_quit = true;
				return;
			};
		case => void;
		};
	};
};

export fn update(state: *state) (void | sdl2::error) = {
	process_events(state)?;

	state.t += state.dt;

	for (let i = 0z; i < common::N_OBJECTS; i += 1) {
		state.engine.positions[i][2] += STAR_SPEED * state.dt;
		if (state.engine.positions[i][2] > STAR_Z_MAX) {
			randomize_object_xy(state, i);
			state.engine.positions[i][2] = STAR_Z_MIN;
		};
	};
};

fn randomize_object_xy(state: *state, idx: size) void = {
	state.engine.positions[idx][0] =
		(random::next(&state.rng) % STAR_XY_EXTENT: i32: u32): i64: f32 -
		(STAR_XY_EXTENT / 2.0);
	state.engine.positions[idx][1] =
		(random::next(&state.rng) % STAR_XY_EXTENT: i32: u32): i64: f32 -
		(STAR_XY_EXTENT / 2.0);
};

fn randomize_object_z(state: *state, idx: size) void = {
	const extent = (math::absf64(STAR_Z_MIN) +
		math::absf64(STAR_Z_MAX)): i64: u64;
	state.engine.positions[idx][2] =
		(random::next(&state.rng) % extent): i64: f32 + STAR_Z_MIN;
};

fn init_objects(state: *state) void = {
	state.engine.positions = [glm::v3_new(0.0, 0.0, 0.0)...];
	state.engine.rotations = [0.0...];
	state.engine.scales = [0.1...];
	state.engine.colors = [glm::v3_new(1.0, 1.0, 1.0)...];

	for (let i = 0z; i < common::N_OBJECTS; i += 1) {
		randomize_object_xy(state, i);
		randomize_object_z(state, i);
	};
};

export fn init(state: *state) void = {
	init_objects(state);
};
