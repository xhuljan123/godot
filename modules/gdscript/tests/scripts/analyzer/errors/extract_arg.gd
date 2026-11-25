const NUMBER = 1

func foo(arg1: int, arg2: String) -> void:
	pass

func no_args() -> void:
	pass

type OutOfRange = ExtractArg[foo][2]
type Negative = ExtractArg[foo][-1]
type NoArgs = ExtractArg[no_args][0]
type StringIndex = ExtractArg[foo]["0"]
type FromNumber = ExtractArg[NUMBER][0]
type FromClass = ExtractArg[Node][0]

func test():
	var number := 1
	var value: ExtractArg[foo][1] = number
	print(value)
