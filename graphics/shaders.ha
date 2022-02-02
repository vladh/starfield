use errors;
use fmt;
use strings;

use gl;
use util;

def VERT_SHADER: str = "
#version 330 core
layout (location = 0) in vec3 pos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	gl_Position = projection * view * model * vec4(pos.x, pos.y, pos.z, 1.0);
}
\0";

def FRAG_SHADER: str = "
#version 330 core
out vec4 out_color;

void main()
{
	out_color = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
\0";

fn make_shader(source: str, kind: uint) (uint | errors::invalid) = {
	const shader = gl::glCreateShader(kind);
	const cstr = util::cstr(source);
	gl::glShaderSource(shader, 1, &cstr, null: *const i32);
	gl::glCompileShader(shader);

	let success: i32 = 1;
	let log: [512]u8 = [0...];
	gl::glGetShaderiv(shader, gl::COMPILE_STATUS, &success);
	if (success == 0) {
		gl::glGetShaderInfoLog(shader, 512, null: *const i32, &log[0]: *i8);
		const log_str = strings::fromutf8(log);
		fmt::printfln("Shader compilation failed: {}", log_str)!;
		return errors::invalid;
	};

	return shader;
};

fn make_shader_program(vert: uint, frag: uint) (uint | errors::invalid) = {
	const program = gl::glCreateProgram();
	gl::glAttachShader(program, vert);
	gl::glAttachShader(program, frag);
	gl::glLinkProgram(program);

	let success: i32 = 1;
	let log: [512]u8 = [0...];
	gl::glGetShaderiv(program, gl::LINK_STATUS, &success);
	if (success == 0) {
		gl::glGetShaderInfoLog(program, 512, null: *const i32, &log[0]: *i8);
		const log_str = strings::fromutf8(log);
		fmt::printfln("Shader program linking failed: {}", log_str)!;
		return errors::invalid;
	};

	return program;
};
