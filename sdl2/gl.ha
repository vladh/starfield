export type glcontext = void;

export @symbol("SDL_GL_CreateContext") fn gl_create_context(window: *window) *glcontext;
export @symbol("SDL_GL_SwapWindow") fn gl_swap_window(window: *window) void;
