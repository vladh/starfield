use math::random;

use glm::{ v3, v4, m4 };
use sdl2;

export type drawable = struct {
	vbo: uint,
	vao: uint,
	ebo: uint,
	shader_program: uint,
};

export type graphics_state = struct {
	cube: drawable,
	object_shader_prog: uint,
	projection: m4,
	view: m4,
};

export type engine_state = struct {
	positions: [N_OBJECTS]v3,
	rotations: [N_OBJECTS]f32,
	scales: [N_OBJECTS]f32,
	colors: [N_OBJECTS]v3,
};

export type state = struct {
	should_quit: bool,
	window: *sdl2::SDL_Window,
	rng: random::random,
	t: f32,
	dt: f32,
	graphics: graphics_state,
	engine: engine_state,
};
