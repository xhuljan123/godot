func test():
	var foo := inferType(func(arg1: int, arg2 = 1.0): return arg1)
	foo.call("1")
	var text: String = foo.call(1)
	foo = func(a: String, b: float) -> int: return 1
	print(text)
