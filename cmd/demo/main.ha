use fmt;
use fs;
use gl::gl;
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
	gl::viewport(0, 0, WINDOW_WIDTH: size, WINDOW_HEIGHT: size);

	gl::clear_depth(1.0);
	gl::clear_color(1.0, 1.0, 1.0, 1.0);
	gl::enable(gl::DEPTH_TEST);

	gl::matrix_mode(gl::PROJECTION);
	gl::load_identity();
	let mat: [16]f32 = [0.0...];
	let aspect = WINDOW_WIDTH: f32 / WINDOW_HEIGHT: f32;
	glm::make_perspective(&mat, 70.0, aspect, 0.1, 100.0);
	gl::load_matrix_f32(&mat[0]);
};

fn draw(state: *state) (void | sdl2::error) = {
	gl::clear(gl::COLOR_BUFFER_BIT | gl::DEPTH_BUFFER_BIT);

	gl::matrix_mode(gl::MODELVIEW);
	gl::load_identity();
	gl::translatef(0.0, 0.0, -4.0);
	gl::rotatef(state.rotation, 0.0, 1.0, 0.0);
	gl::rotatef(state.rotation / 2.0, 1.0, 0.0, 1.0);

	gl::begin(gl::QUADS);
	gl::color3f(0.0, 1.0, 0.0);
	gl::vertex3f( 1.0, 1.0, -1.0);
	gl::vertex3f(-1.0, 1.0, -1.0);
	gl::vertex3f(-1.0, 1.0,  1.0);
	gl::vertex3f( 1.0, 1.0,  1.0);

	gl::color3f(1.0, 0.5, 0.0);
	gl::vertex3f( 1.0, -1.0,  1.0);
	gl::vertex3f(-1.0, -1.0,  1.0);
	gl::vertex3f(-1.0, -1.0, -1.0);
	gl::vertex3f( 1.0, -1.0, -1.0);

	gl::color3f(1.0, 0.0, 0.0);
	gl::vertex3f( 1.0,  1.0, 1.0);
	gl::vertex3f(-1.0,  1.0, 1.0);
	gl::vertex3f(-1.0, -1.0, 1.0);
	gl::vertex3f( 1.0, -1.0, 1.0);

	gl::color3f(1.0, 1.0, 0.0);
	gl::vertex3f( 1.0, -1.0, -1.0);
	gl::vertex3f(-1.0, -1.0, -1.0);
	gl::vertex3f(-1.0,  1.0, -1.0);
	gl::vertex3f( 1.0,  1.0, -1.0);

	gl::color3f(0.0, 0.0, 1.0);
	gl::vertex3f(-1.0,  1.0,  1.0);
	gl::vertex3f(-1.0,  1.0, -1.0);
	gl::vertex3f(-1.0, -1.0, -1.0);
	gl::vertex3f(-1.0, -1.0,  1.0);

	gl::color3f(1.0, 0.0, 1.0);
	gl::vertex3f(1.0,  1.0, -1.0);
	gl::vertex3f(1.0,  1.0,  1.0);
	gl::vertex3f(1.0, -1.0,  1.0);
	gl::vertex3f(1.0, -1.0, -1.0);
	gl::end();

	sdl2::gl_swap_window(state.window);
};
