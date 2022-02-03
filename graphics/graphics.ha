use fmt;
use math;
use util;

use gl;
use glm;
use glm::{ v3, v4, m4 };
use sdl2::sdl2;

use common;
use common::{ state };

export fn init(state: *state) void = {
	gl::load();

	init_buffers(state);
	init_shaders(state);
	init_matrices(state);

	gl::glViewport(0, 0,
		common::WINDOW_WIDTH: i32, common::WINDOW_HEIGHT: i32);

	gl::glClearColor(1.0, 1.0, 1.0, 1.0);
};

fn init_buffers(state: *state) void = {
	gl::glGenVertexArrays(1, &state.graphics.vao);
	gl::glBindVertexArray(state.graphics.vao);

	gl::glGenBuffers(1, &state.graphics.vbo);
	gl::glBindBuffer(gl::ARRAY_BUFFER, state.graphics.vbo);
	gl::glBufferData(gl::ARRAY_BUFFER,
		(len(common::VERTICES) * 3 * 4): uintptr,
		glm::v3_valptr(&common::VERTICES[0]): *void,
		gl::STATIC_DRAW);

	gl::glVertexAttribPointer(0, 3, gl::FLOAT, gl::FALSE, 3 * 4,
		null: *const void);
	gl::glEnableVertexAttribArray(0);
};

fn init_shaders(state: *state) void = {
	const vert = make_shader(VERT_SHADER, gl::VERTEX_SHADER)!;
	const frag = make_shader(FRAG_SHADER, gl::FRAGMENT_SHADER)!;
	state.graphics.shader_program = make_shader_program(vert, frag)!;
	gl::glDeleteShader(vert);
	gl::glDeleteShader(frag);
};

fn init_matrices(state: *state) void = {
	const aspect = common::WINDOW_WIDTH: f32 / common::WINDOW_HEIGHT: f32;
	glm::perspective(&state.graphics.projection, 70.0, aspect, 0.1, 100.0);

	state.graphics.view = glm::lookat(
		&glm::v3_make(4.0, 4.0, 4.0),
		&glm::v3_make(0.0, 0.0, 0.0),
		&glm::v3_make(0.0, 1.0, 0.0));
};

export fn destroy(state: *state) void = {
	gl::glDeleteVertexArrays(1, &state.graphics.vao);
	gl::glDeleteBuffers(1, &state.graphics.vbo);
	gl::glDeleteProgram(state.graphics.shader_program);
};

export fn draw(state: *state) (void | sdl2::error) = {
	const shaderprog = state.graphics.shader_program;

	gl::glClear(gl::COLOR_BUFFER_BIT);
	gl::glBindVertexArray(state.graphics.vao);
	gl::glUseProgram(shaderprog);

	let model = glm::m4_make(1.0);
	glm::rotate(&model, state.t / 5.0, &glm::v3_make(1.0, 0.0, 0.5));

	const uniforms = [
		("model\0", &model),
		("view\0", &state.graphics.view),
		("projection\0", &state.graphics.projection),
	];
	for (let i = 0z; i < len(uniforms); i += 1) {
		const uniform = uniforms[i];
		const loc = gl::glGetUniformLocation(shaderprog,
			util::cstr(uniform.0));
		gl::glUniformMatrix4fv(loc, 1, 0, glm::m4_valptr(uniform.1));
	};

	gl::glDrawArrays(gl::TRIANGLES, 0, len(common::VERTICES): i32);

	sdl2::gl_swap_window(state.window);
};
