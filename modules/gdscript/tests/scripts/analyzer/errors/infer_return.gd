enum Bar { KEY_1, KEY_2 }
enum Other { OTHER_1 }

func pick(arg: Dictionary) -> Infer[arg]:
	return arg

func identity(arg: Variant) -> Infer[arg]:
	return arg

func wrong_name(arg: int) -> Infer[other]:
	return arg

func not_a_name(arg: int) -> Infer[arg.x]:
	return arg

var not_return: Infer[Bar]

func test():
	var a := pick(Bar)
	a = Other.OTHER_1
	var b := pick({ key_1: 1 })
	print(b.key_2)
	var c := identity(1)
	c = "one"
	print(a, b, c)
