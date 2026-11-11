func foo(arg: List["foo", "bar", 1]) -> void:
	print(arg)

func test():
	var untyped = "baz"
	foo(untyped)
