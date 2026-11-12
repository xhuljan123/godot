const NUMBER = 1
type FromNumber = FunctionArgType[NUMBER]
type FromClass = FunctionArgType[Node]

func foo(arg_1: int, arg_2 := "bar"):
	pass

func test():
	var callback: FunctionArgType[foo] = func(a: String, b: String) -> void: pass
	print(callback)
