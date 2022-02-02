use types;

export fn cstr(s: str) *const i8 = {
	return ((&s): *types::string).data: *const i8;
};
