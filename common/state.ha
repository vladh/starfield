use glm::{ m4 };
use sdl2::sdl2;

export type graphics_state = struct {
	vbo: uint,
	vao: uint,
	shader_program: uint,
	projection: m4,
	view: m4,
};

export type engine_state = struct {
	rotation: f32,
};

export type state = struct {
	should_quit: bool,
	window: *sdl2::window,
	t: f32,
	graphics: graphics_state,
	engine: engine_state,
};
