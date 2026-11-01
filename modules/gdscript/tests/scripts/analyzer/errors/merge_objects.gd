type Config = Struct[{ name: String, size: int }]

func test():
	var a: Struct[{ value: int }] = { value = 1 }
	var b: Struct[{ value?: String }] = {}
	var mismatch := mergeObjects(a, b)
	var merged := mergeObjects({ x: 1 }, { y: "a" })
	print(merged.z)
	var not_a_dictionary := mergeObjects(1, {})
	var too_few := mergeObjects({})
	var config: Config = mergeObjects({ name: "a" }, {})
