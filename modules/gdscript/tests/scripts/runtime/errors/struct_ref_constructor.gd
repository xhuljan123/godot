class Foo extends StructRef:
	var foo := 1
	var bar: bool

func test():
	var data: Dictionary = { "foo": "not an int" }
	var foo = Foo.new(data)
	print(foo)
