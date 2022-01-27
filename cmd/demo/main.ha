use fmt;
use fs;
use sdl2::{ event_type, renderer_flags, window_flags };
use sdl2;
use strings;


type state = struct {
	should_quit: bool,
	window: *sdl2::window,
	render: *sdl2::renderer,
};


fn update(state: *state) (void | sdl2::error) = {
	let ev = sdl2::event { ... };
	for (sdl2::poll_event(&ev)? == 1) {
		switch (ev.event_type) {
		case event_type::QUIT =>
			state.should_quit = true;
			return;
		case => void;
		};
	};

	let width = 0, height = 0;
	sdl2::get_window_size(state.window, &width, &height);
};


fn draw(state: *state) (void | sdl2::error) = {
	sdl2::set_render_draw_color(state.render, 50, 50, 200, 255)?;
	sdl2::render_clear(state.render)?;
	sdl2::render_present(state.render);
};


fn run() (void | fs::error | sdl2::error) = {
	sdl2::init(sdl2::init_flags::VIDEO)!;
	defer sdl2::quit();

	const win = sdl2::create_window("starfield",
		sdl2::WINDOWPOS_UNDEFINED, sdl2::WINDOWPOS_UNDEFINED, 640, 480, window_flags::NONE)?;
	defer sdl2::destroy_window(win);

	const render = sdl2::create_renderer(win, -1, renderer_flags::NONE)?;
	defer sdl2::destroy_renderer(render);

	let state = state {
		window = win,
		render = render,
		...
	};

	for (!state.should_quit) {
		update(&state)?;
		draw(&state)?;
		sdl2::delay(1000 / 60);
	};
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
