type Config = Struct[{ id: int, name: String, size?: int }]

func test():
	var full: Required[Config] = { id = 1, name = "a" }
	var patch: Partial[Config, { id }] = { name = "a" }
	var unknown_key: Partial[Config, { nope }]
	var not_a_struct: Required[int]
