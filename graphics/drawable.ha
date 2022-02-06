use math;

use gl;
use glm;
use glm::{ v3, v4, m4 };

use common;
use common::{ state, drawable };

fn init_buffers(drawable: *drawable) void = {
	for (let i = 0z; i < len(common::BUNNY_INDICES); i += 1) {
		common::BUNNY_INDICES[i] -= 1;
	};
	gl::glGenVertexArrays(1, &drawable.vao);
	gl::glBindVertexArray(drawable.vao);

	const vertex_size: size = 9 * 4;

	gl::glGenBuffers(1, &drawable.vbo);
	gl::glBindBuffer(gl::GL_ARRAY_BUFFER, drawable.vbo);
	gl::glBufferData(gl::GL_ARRAY_BUFFER,
		(len(common::BUNNY_VERTICES) * vertex_size): uintptr,
		&common::BUNNY_VERTICES[0]: *void,
		gl::GL_STATIC_DRAW);

	gl::glGenBuffers(1, &drawable.ebo);
	gl::glBindBuffer(gl::GL_ELEMENT_ARRAY_BUFFER, drawable.ebo);
	gl::glBufferData(gl::GL_ELEMENT_ARRAY_BUFFER,
		(len(common::BUNNY_INDICES) * 4): uintptr,
		&common::BUNNY_INDICES[0]: *void,
		gl::GL_STATIC_DRAW);

	gl::glVertexAttribPointer(0, 3, gl::GL_FLOAT, gl::GL_FALSE, vertex_size: i32,
		null: *const void);
	gl::glEnableVertexAttribArray(0);

	gl::glVertexAttribPointer(1, 3, gl::GL_FLOAT, gl::GL_FALSE, vertex_size: i32,
		(3 * 4): uintptr: *const void);
	gl::glEnableVertexAttribArray(1);

	gl::glVertexAttribPointer(2, 3, gl::GL_FLOAT, gl::GL_FALSE, vertex_size: i32,
		(6 * 4): uintptr: *const void);
	gl::glEnableVertexAttribArray(2);
};

export fn init_drawable(drawable: *drawable, prog: uint) void = {
	drawable.shader_program = prog;
	init_buffers(drawable);
};

export fn draw_drawable(
	drawable: *drawable,
	state: *state, // TODO: Remove once UBO is added
	model: *m4,
	color: *v3
) void = {
	gl::glBindVertexArray(drawable.vao);
	gl::glBindBuffer(gl::GL_ELEMENT_ARRAY_BUFFER, drawable.ebo);
	gl::glUseProgram(drawable.shader_program);

	// TODO: Move to UBO
	uniformmat4fv(drawable.shader_program, "view\0", &state.graphics.view);
	uniformmat4fv(drawable.shader_program, "projection\0", &state.graphics.projection);
	uniform1f(drawable.shader_program, "t\0", state.t);

	uniformmat4fv(drawable.shader_program, "model\0", model);
	uniform3fv(drawable.shader_program, "uniform_color\0", color);

	gl::glDrawElements(gl::GL_TRIANGLES, len(common::BUNNY_INDICES): i32,
		gl::GL_UNSIGNED_INT, 0: uintptr: *void);
};

export fn destroy_drawable(drawable: *drawable) void = {
	gl::glDeleteVertexArrays(1, &drawable.vao);
	gl::glDeleteBuffers(1, &drawable.vbo);
};
