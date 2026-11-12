# `FunctionArgType[function]`: a `Callable[...]` with the argument types of a function.
func foo(arg_1: int, arg_2 := "bar") -> String:
	return "%d %s" % [arg_1, arg_2]

static func twice(value: float) -> float:
	return value * 2.0

class Inner:
	static func greet(name: String, times: int) -> void:
		print(name.repeat(times))

type Bar = FunctionArgType[foo] # Callable[int, String], `arg_2` stays optional.
type GreetArgs = FunctionArgType[Inner.greet] # Callable[String, int]

func run(callback: Bar) -> void:
	print(callback.call(1))
	print(callback.call(2, "baz"))

func test():
	run(foo)
	run(func(a: int, b: String = "lambda") -> String: return "%d-%s" % [a, b])
	var greet: GreetArgs = Inner.greet
	greet.call("ab", 2)
	var scale: FunctionArgType[twice] = twice
	print(scale.call(1.5))
