func no_return(value: int):
	return value

func returns_string(value: int) -> String:
	return str(value)

func test():
	var a: Callable[int][int] = func(value: int) -> String: return str(value)
	var b: Callable[int][int] = no_return
	var c: Callable[int][int] = func(value: int) -> void: print(value)
	var d: Callable[int][int] = func(value: int): return value
	var e: Callable[int][String] = returns_string
	var f: int = e.call(1)
	var g: Callable[int][void] = returns_string
	var h = g.call(1)
