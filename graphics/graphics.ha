use sdl2::sdl2;

use gl;
use glm::glm;
use glm::glm::{ v3 };

use common;
use common::{ state };

fn init_buffers(state: *state) void = {
	void;
};

export fn init(state: *state) void = {
	gl::load();

	init_buffers(state);

	gl::glViewport(0, 0,
		common::WINDOW_WIDTH: i32, common::WINDOW_HEIGHT: i32);

	gl::glClearDepth(1.0);
	gl::glClearColor(1.0, 1.0, 1.0, 1.0);
	gl::glEnable(gl::DEPTH_TEST);

	gl::glMatrixMode(gl::PROJECTION);
	gl::glLoadIdentity();
	let mat: [16]f32 = [0.0...];
	let aspect = common::WINDOW_WIDTH: f32 / common::WINDOW_HEIGHT: f32;
	glm::make_perspective(&mat, 70.0, aspect, 0.1, 100.0);
	gl::glLoadMatrixf(&mat[0]);
};

export fn draw(state: *state) (void | sdl2::error) = {
	gl::glClear(gl::COLOR_BUFFER_BIT | gl::DEPTH_BUFFER_BIT);

	gl::glMatrixMode(gl::MODELVIEW);
	gl::glLoadIdentity();
	gl::glTranslatef(0.0, 0.0, -4.0);
	gl::glRotatef(state.rotation, 0.0, 1.0, 0.0);
	gl::glRotatef(state.rotation / 2.0, 1.0, 0.0, 1.0);

	gl::glBegin(gl::TRIANGLES);
	for (let i = 0z; i < len(common::VERTICES); i += 1) {
		gl::glColor3f(
			(i % 2): i32: f32,
			(i % 3): i32: f32,
			(i % 4): i32: f32
		);
		gl::glVertex3f(
			common::VERTICES[i].x,
			common::VERTICES[i].y,
			common::VERTICES[i].z
		);
	};
	gl::glEnd();

	sdl2::gl_swap_window(state.window);
};
