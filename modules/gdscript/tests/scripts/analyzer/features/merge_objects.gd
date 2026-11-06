# `mergeObjects()` merges two structs into a new one, values from the second one win.
# The result is a struct with the keys of both.
type Config = Struct[{ name: String, size: int }]

func make_config(options: Partial[Config]) -> Config:
	var defaults: Config = { name = "default", size = 1 }
	return mergeObjects(defaults, options)

func test():
	print(make_config({ size = 5 }))
	print(make_config({}))

	# Dictionary literals are typed like with `inferType()`.
	var merged := mergeObjects({ a: 1, b: "x" }, { b: "y", c: [1.0] })
	print(merged.a + 1, " ", merged.b.to_upper(), " ", merged.c[0])
	print(merged)

	# The arguments are not modified.
	var base: Struct[{ hp: int }] = { hp = 10 }
	var extra: Struct[{ hp: int, mp: int }] = { hp = 20, mp = 5 }
	var result := mergeObjects(base, extra)
	print(base, " ", extra, " ", result)

	# The result type has the keys of both, with their types and default values.
	var stats: Struct[{ hp: int, mp: int }] = result
	print(stats.mp)
	var with_default: Struct[{ level = 1 }] = {}
	var leveled := mergeObjects(base, with_default)
	var level: int = leveled.level
	print(level)
