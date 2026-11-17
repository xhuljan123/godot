# `-> Infer[param]`: each call is typed from the argument passed for the parameter.
enum Bar { KEY_1, KEY_2 }

func first(arg: Dictionary) -> Infer[arg]:
	if arg.has("KEY_1"):
		return arg.KEY_1
	return arg

func identity(arg: Variant) -> Infer[arg]:
	return arg

func with_default(value: int = 3) -> Infer[value]:
	return value * 2

static func untyped(value) -> Infer[value]:
	return value

func random_value(_enum: Dictionary) -> Infer[_enum]:
	return _enum[_enum.keys().pick_random()]

var member := random_value(Bar) # Bar

func test():
	var a := first(Bar) # Bar
	var bar: Bar = a
	print(bar == Bar.KEY_1)

	var b := first({ key_1: 1 }) # Struct[{ key_1: int }]
	b.key_1 += 1
	print(b.key_1)

	var c := identity(1) # int
	print(c + 1, " ", typeof(c) == TYPE_INT)

	var d := identity("text") # String
	print(d.to_upper())

	var e := identity([1, 2]) # Array[int]
	print(e.is_typed(), " ", e.get_typed_builtin() == TYPE_INT)

	var f := with_default() # int
	print(f)

	var g := untyped(Vector2(1, 2)) # Vector2
	print(g.x)

	var h := identity(func(x: int) -> int: return x + 1) # Callable[int][int]
	var result: int = h.call(1)
	print(result)

	var member_value: Bar = member
	print(member_value == Bar.KEY_1 or member_value == Bar.KEY_2)
