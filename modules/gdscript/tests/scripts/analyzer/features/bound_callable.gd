# `BoundCallable`: the type of `bind_strict()` results, which can only be called without arguments.
func foo(arg: int) -> String:
	return "foo %d" % arg

func greet(name: String):
	print("hello ", name)

func run(callback: BoundCallable[String]) -> String:
	return callback.call()

func test():
	var bar := foo.bind_strict(1) # `BoundCallable[String]`, kept by `:=`.
	var text: String = bar.call()
	print(text)
	print(run(foo.bind_strict(2)))
	var later: BoundCallable = greet.bind_strict("Bob")
	later.call()
	print(bar.is_valid())

	# It can still be used where a plain `Callable` (or a callable without arguments) is expected.
	var plain: Callable = bar
	print(plain.call())
	var no_args: Callable[][String] = bar
	print(no_args.call())
