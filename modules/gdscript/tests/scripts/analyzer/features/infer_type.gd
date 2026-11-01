# `inferType()` types a dictionary literal as the struct inferred from its keys and values.

func greet(person: Struct[{ name: String, age: int }]) -> String:
	return "%s (%d)" % [person.name, person.age]

func test():
	# TypeScript-like keys: `Struct[{ key1: int, key2: Array[String] }]`.
	var foo := inferType({ key1: 1, key2: ["test"] })
	print(foo.key1 + 1, " ", foo.key2[0].to_upper())
	print(foo.key2.is_typed(), " ", type_string(foo.key2.get_typed_builtin()))

	# Lua-style keys, used where a compatible struct is expected.
	var bob := inferType({ name = "Bob", age = 42 })
	print(greet(bob))

	# Nested structs and arrays of structs.
	var level := inferType({
		title: "Forest",
		spawn: { x: 1.0, y: 2.0 },
		points: [{ x: 1.0, y: 1.0 }, { x: 2.0, y: 0.5 }],
	})
	print(level.title, " ", level.spawn.x + level.spawn.y)
	var total := 0.0
	for point in level.points:
		total += point.x + point.y
	print(total)

	# Mixed or empty arrays stay untyped, `null` gives a `Variant` key.
	var mixed := inferType({ items: [1, "a"], empty: [], nothing: null, shapes: [{ a: 1 }, { b: "x" }] })
	print(mixed.items.is_typed(), " ", mixed.empty.is_typed(), " ", mixed.nothing)
	mixed.nothing = 5
	print(mixed.nothing, " ", mixed.shapes[1].b)

	# A value that already has a struct type keeps it.
	var copy := inferType(bob)
	print(copy.name)
