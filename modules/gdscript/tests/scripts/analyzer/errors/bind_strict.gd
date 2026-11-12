func foo(arg_1: int, arg_2 := "bar"):
	pass

func test():
	var a := foo.bind_strict()
	var b := foo.bind_strict("1")
	var c := foo.bind_strict(1, 2)
	var d := foo.bind_strict(1, "bar", "foo")
	var typed: Callable[int] = func(x: int): pass
	var e := typed.bind_strict("x")
	print(a, b, c, d, e)
