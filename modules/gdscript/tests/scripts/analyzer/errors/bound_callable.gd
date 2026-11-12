func foo(arg: int) -> String:
	return "foo %d" % arg

func test():
	var bar := foo.bind_strict(1)
	bar.call(1)
	bar.callv([])
	bar.bind(2)
	var not_bound: BoundCallable = func() -> void: pass
	var wrong_return: BoundCallable[int] = foo.bind_strict(1)
	print(not_bound, wrong_return)
