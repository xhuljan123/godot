func needs_flag(arg: Struct[{ flag: bool }]) -> void:
	print(arg.flag)

func test():
	var foo := inferType({ key1: 1, key2: ["test"], name: "Bob" })
	print(foo.key3)
	foo.name = 5
	needs_flag(foo)
	var plain: Dictionary = {}
	var not_inferred := inferType(plain)
	var no_args := inferType()
