class Foo extends StructRef:
	var key_1: int
	var key_2 = "Bar"

func test():
	var data: Dictionary = { "key_2": "test" }
	var foo = Foo.new(data)
	print(foo)
