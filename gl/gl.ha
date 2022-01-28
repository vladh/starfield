export type gl_enum = uint;
export type gl_bitfield = uint;
// export type gl_boolean = u8;
// export type gl_void = void;
// export type gl_byte = i8;
// export type gl_short = i16;
// export type gl_int = i32;
// export type gl_ubyte = u8;
// export type gl_ushort = u16;
// export type gl_uint = u32;
// export type gl_sizei = i32;
// export type gl_float = f32;
// export type gl_clampf = f32;
// export type gl_double = f64;
// export type gl_clampd = f64;

export def QUADS: gl_enum = 0x0007;
export def COLOR_BUFFER_BIT: gl_bitfield = 0x00004000;
export def DEPTH_BUFFER_BIT: gl_bitfield = 0x00000100;
export def MATRIX_MODE: gl_enum = 0x0BA0;
export def MODELVIEW: gl_enum = 0x1700;
export def PROJECTION: gl_enum = 0x1701;
export def TEXTURE: gl_enum = 0x1702;
export def DEPTH_TEST: gl_enum = 0x0B71;
export def LEQUAL: gl_enum = 0x0203;
export def CULL_FACE: gl_enum = 0x0B44;
export def CULL_FACE_MODE: gl_enum = 0x0B45;
export def CW: gl_enum = 0x0900;
export def CCW: gl_enum = 0x0901;

export @symbol("glBegin") fn begin(mode: gl_enum) void;
export @symbol("glEnd") fn end() void;

export @symbol("glVertex3f") fn vertex3f(x: f32, y: f32, z: f32) void;
export @symbol("glColor3f") fn color3f(red: f32, green: f32, blue: f32) void;

export @symbol("glEnable") fn enable(cap: gl_enum) void;
export @symbol("glDisable") fn disable(cap: gl_enum) void;

export @symbol("glFrontFace") fn front_face(mode: gl_enum) void;
export @symbol("glDepthFunc") fn depth_func(func: gl_enum) void;
export @symbol("glClear") fn clear(mask: gl_bitfield) void;
export @symbol("glClearDepth") fn clear_depth(depth: f64) void;
export @symbol("glClearColor") fn clear_color(red: f32, green: f32,
    blue: f32, alpha: f32) void;

export @symbol("glViewport") fn viewport(x: int, y: int,
    width: size, height: size) void;
export @symbol("glLoadMatrixf") fn load_matrix_f32(m: *f32) void;
export @symbol("glMatrixMode") fn matrix_mode(mode: gl_enum) void;
export @symbol("glLoadIdentity") fn load_identity() void;
export @symbol("glPushMatrix") fn push_matrix() void;
export @symbol("glPopMatrix") fn pop_matrix() void;
export @symbol("glTranslatef") fn translatef(x: f32, y: f32, z: f32) void;
export @symbol("glRotatef") fn rotatef(angle: f32, x: f32, y: f32, z: f32) void;
