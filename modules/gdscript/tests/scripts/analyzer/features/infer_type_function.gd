# `inferType(function)`: the full signature of a lambda or function, as a typed callable.
func double(value: int) -> int:
	return value * 2

func test():
	# `Callable[int, float][int]`: `arg2` is typed from its default value, the return type from the `return` statements.
	var foo := inferType(func(arg1: int, arg2 = 1.0):
		if arg1 > 10:
			return arg1
		return int(arg2) + arg1
	)
	var total: int = foo.call(2)
	print(total)
	print(foo.call(20, 2.5))

	var printer := inferType(func(text: String): print(text)) # `Callable[String]`: no return value.
	printer.call("no return value")

	var annotated := inferType(func(a: String) -> String: return a.to_upper())
	print(annotated.call("abc"))

	var reference := inferType(double)
	print(reference.call(4))

	var mixed := inferType(func(flag: bool): # `Callable[bool][Variant]`.
		if flag:
			return 1
		return "one"
	)
	print(mixed.call(false))

	# The signature is kept, so it can be passed where a typed callable is expected.
	var typed: Callable[int, float][int] = foo
	print(typed.call(1, 1.0))

	var player := inferType({ name: "Bob" })
	print(player.name)
