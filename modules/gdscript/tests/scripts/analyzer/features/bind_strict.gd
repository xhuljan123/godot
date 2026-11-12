# `bind_strict()`: like `bind()`, but the bound arguments are checked against the signature of the function.
func foo(arg_1: int, arg_2 := "bar") -> String:
	return "%d %s" % [arg_1, arg_2]

func no_return(value: int):
	print("no_return ", value)

func test():
	var bound := foo.bind_strict(1) # Valid, since `arg_2` is optional.
	print(bound.call())
	print(foo.bind_strict(2, "baz").call()) # The result keeps the return type of `foo()`.

	var typed: Callable[int, String] = func(a: int, b: String) -> String: return "%d%s" % [a, b]
	print(typed.bind_strict(3, "x").call())

	print(no_return.bind_strict(4).call())
	print((func(x: float): return x * 2.0).bind_strict(1.5).call())

	# `bind()` is unchanged.
	print(foo.bind("q").call(6))
