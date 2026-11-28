# Typed object keys: `Struct[{ key: Type, optional_key?: Type }]`.

class Item:
	var id: int
	func _init(p_id: int) -> void:
		id = p_id

func foo(arg: Struct[{ key1: String, key2: int }]) -> void:
	print(arg.key1)
	print(arg.key2 + 1)

func person_name(person: Struct[{ name: String, age?: int }]) -> String:
	if person.has("age"):
		return "%s (%d)" % [person.name, person.age]
	return person.name

func make_point(x: float, y: float) -> Struct[{ x: float, y: float }]:
	return { x = x, y = y }

func sum_points(points: Array[Struct[{ x: float, y: float }]]) -> float:
	var total := 0.0
	for point in points:
		total += point.x + point.y
	return total

func describe(entity: Struct[{
	id: int,
	"display name": String,
	position: Struct[{ x: float, y: float }],
	tags: Array[String],
	stats?: Dictionary[String, int],
	item?: Item,
	extra?: Variant,
}]) -> void:
	print(entity.id, " ", entity["display name"], " ", entity.position.x, ",", entity.position.y)
	print(entity.tags)
	if entity.has("stats"):
		print(entity.stats)
	if entity.has("item"):
		print(entity.item.id)

func test():
	# TypeScript-like literal (bare keys are key names).
	foo({ key1: "1", key2: 1 })
	# Lua-style and string keys are accepted too.
	foo({ key1 = "a", key2 = 2 })
	foo({ "key1": "b", "key2": 3 })

	# Optional keys.
	print(person_name({ name: "Ann" }))
	print(person_name({ name: "Bob", age: 42 }))

	# Bare key names work even when a variable with the same name exists.
	var name := "not a key"
	print(person_name({ name: name }))

	# Struct-typed variables, deep typing, typed containers inside structs.
	var entity: Struct[{ id: int, "display name": String, position: Struct[{ x: float, y: float }], tags: Array[String], stats?: Dictionary[String, int], item?: Item, extra?: Variant }] = {
		id: 7,
		"display name": "Hero",
		position: { x: 1, y: 2.5 },
		tags: ["a", "b"],
		stats: { "hp": 10 },
		item: Item.new(99),
	}
	describe(entity)
	describe({ id: 1, "display name": "Minimal", position: { x: 0.0, y: 0.0 }, tags: [] })

	# Key assignment keeps the type.
	entity.position.x = 10
	entity.id += 1
	print(entity.position.x, " ", entity.id)

	# Return types and arrays of structs.
	var p := make_point(1.5, 2.0)
	print(p.x + p.y)
	print(sum_points([{ x: 1.0, y: 2.0 }, make_point(3.0, 4.0)]))

	# Structural typing: extra keys are fine when assigning a struct variable.
	var big: Struct[{ key1: String, key2: int, other: bool }] = { key1: "big", key2: 5, other: true }
	foo(big)

	# Constant structs.
	const ORIGIN: Struct[{ x: float, y: float }] = { x: 0.0, y: 0.0 }
	print(ORIGIN.x, " ", ORIGIN["y"])

	# Typed dictionary values.
	var by_name: Dictionary[String, Struct[{ x: float, y: float }]] = { "a": { x: 1.0, y: 1.0 } }
	print(by_name["a"].y)

	# Plain dictionaries can be passed (checked at runtime).
	var untyped: Dictionary = { "key1": "untyped", "key2": 8 }
	foo(untyped)

	# Normal dictionaries are unchanged.
	var key1 := "dynamic"
	var normal := { key1: 1 }
	print(normal)
