use sdl2::sdl2;

use gl;
use glm::glm;
use glm::glm::{ v3 };

use common;
use common::{ state };

fn init_buffers(state: *state) void = {
	gl::glGenVertexArrays(1, &state.graphics.vao);
	gl::glBindVertexArray(state.graphics.vao);

	gl::glGenBuffers(1, &state.graphics.vbo);
	gl::glBindBuffer(gl::ARRAY_BUFFER, state.graphics.vbo);
	gl::glBufferData(gl::ARRAY_BUFFER,
		(len(common::VERTICES) * 3 * 4): uintptr,
		&common::VERTICES[0]: *void,
		gl::STATIC_DRAW);

	gl::glVertexAttribPointer(0, 3, gl::FLOAT, gl::FALSE, 3 * 32 / 8,
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

export fn init(state: *state) void = {
	gl::load();

	init_buffers(state);
	init_shaders(state);

	gl::glViewport(0, 0,
		common::WINDOW_WIDTH: i32, common::WINDOW_HEIGHT: i32);

	gl::glClearDepth(1.0);
	gl::glClearColor(1.0, 1.0, 1.0, 1.0);
	gl::glEnable(gl::DEPTH_TEST);

	// gl::glMatrixMode(gl::PROJECTION);
	// gl::glLoadIdentity();

	// let mat: [16]f32 = [0.0...];
	// let aspect = common::WINDOW_WIDTH: f32 / common::WINDOW_HEIGHT: f32;
	// glm::make_perspective(&mat, 70.0, aspect, 0.1, 100.0);

	// gl::glLoadMatrixf(&mat[0]);
};

export fn draw(state: *state) (void | sdl2::error) = {
	gl::glClear(gl::COLOR_BUFFER_BIT | gl::DEPTH_BUFFER_BIT);

	gl::glUseProgram(state.graphics.shader_program);
	gl::glBindVertexArray(state.graphics.vao);

	// gl::glMatrixMode(gl::MODELVIEW);
	// gl::glLoadIdentity();
	// gl::glTranslatef(0.0, 0.0, -4.0);
	// gl::glRotatef(state.engine.rotation, 0.0, 1.0, 0.0);
	// gl::glRotatef(state.engine.rotation / 2.0, 1.0, 0.0, 1.0);

	// gl::glBegin(gl::TRIANGLES);
	// for (let i = 0z; i < len(common::VERTICES); i += 1) {
	// 	gl::glColor3f(
	// 		(i % 2): i32: f32,
	// 		(i % 3): i32: f32,
	// 		(i % 4): i32: f32
	// 	);
	// 	gl::glVertex3f(
	// 		common::VERTICES[i].x,
	// 		common::VERTICES[i].y,
	// 		common::VERTICES[i].z
	// 	);
	// };
	// gl::glEnd();

	sdl2::gl_swap_window(state.window);
};
