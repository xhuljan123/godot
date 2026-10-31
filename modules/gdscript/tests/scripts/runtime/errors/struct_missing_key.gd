func foo(arg: Struct[{ key1: String, key2: int }]) -> void:
	print(arg.key1)

func test():
	var missing: Dictionary = { "key1": "a" }
	foo(missing)
