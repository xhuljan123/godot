func takes_callback(callback: Callable[int]) -> void:
	callback.call()

func test():
	var foo: Callable[int, String] = func(number: int, text: String = "") -> void:
		print(number, text)
	foo.call()
	foo.call(1, "a", 2)
	foo.call("a")
	var too_few_params: Callable[int, String] = func(number: int) -> void:
		print(number)
	var wrong_param: Callable[int] = func(text: String) -> void:
		print(text)
	takes_callback(func(a: int, b: int) -> void:
		print(a, b))
	foo = func(number: int, text: String) -> void:
		print(number, text)
	if foo is Callable[int]:
		pass
