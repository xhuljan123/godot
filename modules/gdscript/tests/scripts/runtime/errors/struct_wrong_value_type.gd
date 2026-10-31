func foo(arg: Struct[{ key1: String, nested: Struct[{ count: int }] }]) -> void:
	print(arg.key1)

func test():
	var wrong: Dictionary = { "key1": "a", "nested": { "count": "not an int" } }
	foo(wrong)
