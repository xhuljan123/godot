# `mergeObjects()` merges two dictionaries into a new one, values from the second one win.
# With structs, the result is a struct with the keys of both.
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

	# Plain dictionaries give a plain dictionary, and the arguments are not modified.
	var base := { hp = 10 }
	var extra := { hp = 20, mp = 5 }
	var result := mergeObjects(base, extra)
	print(base, " ", extra, " ", result)
