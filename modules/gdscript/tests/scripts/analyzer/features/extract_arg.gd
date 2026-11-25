# `ExtractArg[function][index]`: the type of one argument of a function.
func foo(arg1: int, arg2: Struct[{ key_1: int }]) -> void:
	print(arg1, " ", arg2.key_1)

func untyped(value, count := 2) -> void:
	print(value, count)

class Inner:
	static func greet(text: String, times: int) -> void:
		print(text.repeat(times))

const SECOND = 1

type A = ExtractArg[foo][0] # int
type B = ExtractArg[foo][1] # Struct[{ key_1: int }]

func use_b(value: B) -> int:
	return value.key_1

func test():
	var a: A = 5
	var b: B = { key_1 = 3 }
	foo(a, b)
	print(use_b({ key_1 = 7 }))
	var b_copy := b
	print(b_copy.key_1 + 1)

	# Static functions of other classes, and constant indices.
	var text: ExtractArg[Inner.greet][0] = "ab"
	var times: ExtractArg[Inner.greet][SECOND] = 3
	Inner.greet(text, times)

	# An untyped argument gives `Variant`, an inferred one (`count := 2`) its type.
	var anything: ExtractArg[untyped][0] = "text"
	anything = 1.5
	print(anything)
	var count: ExtractArg[untyped][1] = 4
	print(count + 1)
