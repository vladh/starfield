use fmt;
use fs;
use gl;
use glm::glm;
use math;
use sdl2::sdl2::{ event_type, keycode, window_flags };
use sdl2::sdl2;
use strings;

def WINDOW_WIDTH: int = 800;
def WINDOW_HEIGHT: int = 600;

type state = struct {
	should_quit: bool,
	window: *sdl2::window,
	rotation: f32,
};

export fn main() void = {
	gl::load();
	match (run()) {
	case let err: sdl2::error =>
		fmt::fatal("SDL2 error: {}", sdl2::strerror(err));
	case let err: fs::error =>
		fmt::fatal("Error: {}", fs::strerror(err));
	case void => void;
	};
};

fn run() (void | fs::error | sdl2::error) = {
	sdl2::init(sdl2::init_flags::VIDEO)!;
	defer sdl2::quit();

	const win = sdl2::create_window("starfield",
		sdl2::WINDOWPOS_UNDEFINED, sdl2::WINDOWPOS_UNDEFINED,
		WINDOW_WIDTH, WINDOW_HEIGHT, window_flags::OPENGL)?;
	defer sdl2::destroy_window(win);

	let context = sdl2::gl_create_context(win);

	let state = state {
		window = win,
		...
	};

	init_gl();

	for (!state.should_quit) {
		update(&state)?;
		draw(&state)?;
		sdl2::delay(1000 / 60);
	};
};

fn update(state: *state) (void | sdl2::error) = {
	state.rotation += 1.0;

	let ev = sdl2::event { ... };
	for (sdl2::poll_event(&ev)? == 1) {
		switch (ev.event_type) {
		case event_type::QUIT =>
			state.should_quit = true;
			return;
		case event_type::KEYDOWN =>
			if (ev.key.keysym.sym == keycode::ESCAPE) {
				state.should_quit = true;
				return;
			};
		case => void;
		};
	};
};

fn init_gl() void = {
	gl::glViewport(0, 0, WINDOW_WIDTH: i32, WINDOW_HEIGHT: i32);

	gl::glClearDepth(1.0);
	gl::glClearColor(1.0, 1.0, 1.0, 1.0);
	gl::glEnable(gl::DEPTH_TEST);

	gl::glMatrixMode(gl::PROJECTION);
	gl::glLoadIdentity();
	let mat: [16]f32 = [0.0...];
	let aspect = WINDOW_WIDTH: f32 / WINDOW_HEIGHT: f32;
	glm::make_perspective(&mat, 70.0, aspect, 0.1, 100.0);
	gl::glLoadMatrixf(&mat[0]);
};

fn draw(state: *state) (void | sdl2::error) = {
	gl::glClear(gl::COLOR_BUFFER_BIT | gl::DEPTH_BUFFER_BIT);

	gl::glMatrixMode(gl::MODELVIEW);
	gl::glLoadIdentity();
	gl::glTranslatef(0.0, 0.0, -4.0);
	gl::glRotatef(state.rotation, 0.0, 1.0, 0.0);
	gl::glRotatef(state.rotation / 2.0, 1.0, 0.0, 1.0);

	gl::glBegin(gl::QUADS);
	gl::glColor3f(0.0, 1.0, 0.0);
	gl::glVertex3f( 1.0, 1.0, -1.0);
	gl::glVertex3f(-1.0, 1.0, -1.0);
	gl::glVertex3f(-1.0, 1.0,  1.0);
	gl::glVertex3f( 1.0, 1.0,  1.0);

	gl::glColor3f(1.0, 0.5, 0.0);
	gl::glVertex3f( 1.0, -1.0,  1.0);
	gl::glVertex3f(-1.0, -1.0,  1.0);
	gl::glVertex3f(-1.0, -1.0, -1.0);
	gl::glVertex3f( 1.0, -1.0, -1.0);

	gl::glColor3f(1.0, 0.0, 0.0);
	gl::glVertex3f( 1.0,  1.0, 1.0);
	gl::glVertex3f(-1.0,  1.0, 1.0);
	gl::glVertex3f(-1.0, -1.0, 1.0);
	gl::glVertex3f( 1.0, -1.0, 1.0);

	gl::glColor3f(1.0, 1.0, 0.0);
	gl::glVertex3f( 1.0, -1.0, -1.0);
	gl::glVertex3f(-1.0, -1.0, -1.0);
	gl::glVertex3f(-1.0,  1.0, -1.0);
	gl::glVertex3f( 1.0,  1.0, -1.0);

	gl::glColor3f(0.0, 0.0, 1.0);
	gl::glVertex3f(-1.0,  1.0,  1.0);
	gl::glVertex3f(-1.0,  1.0, -1.0);
	gl::glVertex3f(-1.0, -1.0, -1.0);
	gl::glVertex3f(-1.0, -1.0,  1.0);

	gl::glColor3f(1.0, 0.0, 1.0);
	gl::glVertex3f(1.0,  1.0, -1.0);
	gl::glVertex3f(1.0,  1.0,  1.0);
	gl::glVertex3f(1.0, -1.0,  1.0);
	gl::glVertex3f(1.0, -1.0, -1.0);
	gl::glEnd();

	sdl2::gl_swap_window(state.window);
};
