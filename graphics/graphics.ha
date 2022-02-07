use fmt;
use math;
use util;

use gl;
use glm;
use glm::{ v3, v4, m4 };
use sdl2;

use common;
use common::{ state };

export fn init(state: *state) void = {
	gl::load();

	gl::glEnable(gl::GL_DEPTH_TEST);

	state.graphics.object_shader_prog = init_shaders(state);
	init_matrices(state);

	init_drawable(&state.graphics.cube, state.graphics.object_shader_prog);

	gl::glViewport(0, 0,
		common::WINDOW_WIDTH: i32, common::WINDOW_HEIGHT: i32);

	gl::glClearColor(0.0, 0.0, 0.0, 1.0);
};

fn init_shaders(state: *state) uint = {
	const vert = make_shader(VERT_SHADER, gl::GL_VERTEX_SHADER)!;
	const frag = make_shader(FRAG_SHADER, gl::GL_FRAGMENT_SHADER)!;
	const prog = make_shader_program(vert, frag)!;
	gl::glDeleteShader(vert);
	gl::glDeleteShader(frag);
	return prog;
};

fn init_matrices(state: *state) void = {
	const aspect = common::WINDOW_WIDTH: f32 / common::WINDOW_HEIGHT: f32;
	glm::perspective(&state.graphics.projection, 70.0, aspect, 0.01, 5000.0);

	state.graphics.view = glm::lookat(
		&glm::v3_new(0.0, 0.0, 15.0),
		&glm::v3_new(0.0, 0.0, 0.0),
		&glm::v3_new(0.0, 1.0, 0.0));
};

export fn destroy(state: *state) void = {
	gl::glDeleteProgram(state.graphics.object_shader_prog);
	destroy_drawable(&state.graphics.cube);
};

export fn draw(state: *state) void = {
	gl::glClear(gl::GL_COLOR_BUFFER_BIT | gl::GL_DEPTH_BUFFER_BIT);

	for (let i = 0z; i < common::N_OBJECTS; i += 1) {
		let model = glm::m4_new(1.0);
		glm::scale(&model, &glm::v3_new_fill(state.engine.scales[i]));

		// Correct bunny position
		glm::rotate(&model, glm::rad(-90.0),
			&glm::v3_new(1.0, 0.0, 0.0));

		glm::rotate(&model, state.engine.rotations[i],
			&glm::v3_new(1.0, 0.0, 0.0));
		glm::translate(&model, &state.engine.positions[i]);

		draw_drawable(&state.graphics.cube, state,
			&model, &state.engine.colors[i]);
	};

	sdl2::SDL_GL_SwapWindow(state.window);
};
