func foo(arg: Struct[{ key1: String, key2?: int }]) -> void:
	print(arg.key1)

func test():
	var extra: Dictionary = { "key1": "a", "key3": 3 }
	foo(extra)
