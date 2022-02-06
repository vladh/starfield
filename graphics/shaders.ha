use errors;
use fmt;
use strings;

use gl;
use glm;
use glm::{ v3, v4, m4 };
use util;

def VERT_SHADER: str = "
#version 330 core
layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec3 vs_normal;
out vec3 vs_color;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	gl_Position = projection * view * model * vec4(pos.x, pos.y, pos.z, 1.0);
	vs_normal = normal;
	vs_color = color;
}
\0";

def FRAG_SHADER: str = "
#version 330 core
out vec4 out_color;

in vec3 vs_normal;
in vec3 vs_color;

uniform float t;
uniform vec3 uniform_color;

void main()
{
	out_color = vec4((vs_normal + 1.0) / 2.0, 1.0);
	// out_color = vec4(
	// 	(uniform_color * 0.3) + vs_color * (((sin(t) + 1.0) / 2) + 0.3),
	// 	1.0f
	// );
}
\0";

fn make_shader(source: str, kind: uint) (uint | errors::invalid) = {
	const shader = gl::glCreateShader(kind);
	const cstr = util::cstr(source);
	gl::glShaderSource(shader, 1, &cstr, null: *const i32);
	gl::glCompileShader(shader);

	let success: i32 = 1;
	let log: [512]u8 = [0...];
	gl::glGetShaderiv(shader, gl::GL_COMPILE_STATUS, &success);
	if (success == 0) {
		gl::glGetShaderInfoLog(shader, 512, null: *const i32,
			&log[0]: *i8);
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
	gl::glGetShaderiv(program, gl::GL_LINK_STATUS, &success);
	if (success == 0) {
		gl::glGetShaderInfoLog(program, 512, null: *const i32,
			&log[0]: *i8);
		const log_str = strings::fromutf8(log);
		fmt::printfln("Shader program linking failed: {}", log_str)!;
		return errors::invalid;
	};

	return program;
};

fn uniformmat4fv(prog: u32, name: str, val: *m4) void = {
	const loc = gl::glGetUniformLocation(prog, util::cstr(name));
	gl::glUniformMatrix4fv(loc, 1, 0, glm::m4_valptr(val));
};

fn uniform3fv(prog: u32, name: str, val: *v3) void = {
	const loc = gl::glGetUniformLocation(prog, util::cstr(name));
	gl::glUniform3fv(loc, 1, glm::v3_valptr(val));
};

fn uniform1f(prog: u32, name: str, val: f32) void = {
	const loc = gl::glGetUniformLocation(prog, util::cstr(name));
	gl::glUniform1f(loc, val);
};
