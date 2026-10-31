func foo(arg: Struct[{ key1: String, key2: int }]) -> void:
	print(arg.key3)
	arg.key1 = 5

func opt(arg: Struct[{ a: int, b?: int }]) -> Struct[{ a: int, b: int }]:
	return arg

func test():
	foo({ key1: "1" })
	foo({ key1: 1, key2: 1 })
	foo({ key1: "1", key2: 1, key3: 3 })
	var nested: Struct[{ inner: Struct[{ x: float }] }] = { inner: { x: "nope" } }
	var smaller: Struct[{ key1: String }] = { key1: "a" }
	foo(smaller)
	var k := "key1"
	foo({ k + "": "a", key2: 1 })
	if nested is Struct[{ inner: Dictionary }]:
		pass
	print(undefined_identifier)
	var not_a_struct := { undefined_key: 1 }
