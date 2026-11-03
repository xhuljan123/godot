func foo(arg: KeyOf[Struct[{ foo: int, bar: String }]]) -> void:
	print(arg)

func test():
	var untyped = "baz"
	foo(untyped)
