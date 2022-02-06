use fmt;
use fs;
use math;
use math::random;
use strings;

use glm::{ v3, m2 };
use sdl2;

use graphics;
use engine;
use common;
use common::{ state };

export fn main() void = {
	match (run()) {
	case let err: sdl2::error =>
		fmt::fatal("SDL2 error: {}", sdl2::strerror(err));
	case let err: fs::error =>
		fmt::fatal("Error: {}", fs::strerror(err));
	case void => void;
	};
};

fn init_state(state: *state, win: *sdl2::window) void = {
	state.window = win;
	state.dt = 1000.0 / 60.0;
	state.rng = random::init(0);
};

fn run() (void | fs::error | sdl2::error) = {
	sdl2::init(sdl2::init_flags::VIDEO)!;
	sdl2::gl_set_attribute(sdl2::glattr::GL_CONTEXT_PROFILE_MASK,
		sdl2::glprofile::GL_CONTEXT_PROFILE_CORE);
	sdl2::gl_set_attribute(sdl2::glattr::GL_CONTEXT_MAJOR_VERSION, 4);
	sdl2::gl_set_attribute(sdl2::glattr::GL_CONTEXT_MINOR_VERSION, 3);
	defer sdl2::quit();

	const win = sdl2::create_window("starfield",
		sdl2::WINDOWPOS_UNDEFINED, sdl2::WINDOWPOS_UNDEFINED,
		common::WINDOW_WIDTH, common::WINDOW_HEIGHT,
		sdl2::window_flags::OPENGL)?;
	defer sdl2::destroy_window(win);

	let context = sdl2::gl_create_context(win);

	let state = state { ... };
	init_state(&state, win);

	graphics::init(&state);
	defer graphics::destroy(&state);

	engine::init(&state);

	for (!state.should_quit) {
		engine::update(&state)?;
		graphics::draw(&state);
		sdl2::delay(state.dt: i32: u32);
	};
};
