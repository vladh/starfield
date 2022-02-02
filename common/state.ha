use sdl2::sdl2;

export type graphics_state = struct {
	vbo: uint,
	vao: uint,
	shader_program: uint,
};

export type engine_state = struct {
	rotation: f32,
};

export type state = struct {
	should_quit: bool,
	window: *sdl2::window,
	graphics: graphics_state,
	engine: engine_state,
};
