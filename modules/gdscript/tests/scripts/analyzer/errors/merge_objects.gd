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
	var plain: Dictionary = {}
	var with_plain := mergeObjects(plain, {})
	var untyped = {}
	var with_untyped := mergeObjects({}, untyped)
	var int_keys := mergeObjects({ 1: "a" }, {})
	var config_extra: Config = mergeObjects({ name: "a" }, { size: 1, extra: true })
	config = mergeObjects(config, { size: 2, colour: "red" })
	var typed_extra: Struct[{ hp: int, mp: int }] = { hp = 1, mp = 2 }
	var from_typed: Struct[{ hp: int }] = mergeObjects({ hp: 1 }, typed_extra)
	take(mergeObjects({ name: "b", size: 2 }, { other: 1 }))

func make(options: Partial[Config]) -> Config:
	return mergeObjects(options, { name: "x", size: 1, debug: true })

func take(config: Config) -> void:
	print(config)
