use sdl2::sdl2;

export type graphics_state = struct {
	vbo: i32,
	vao: i32,
};

export type engine_state = struct {
	rotation: f32,
};

export type state = struct {
	should_quit: bool,
	window: *sdl2::window,
	graphics_state: graphics_state,
	engine_state: engine_state,
};
