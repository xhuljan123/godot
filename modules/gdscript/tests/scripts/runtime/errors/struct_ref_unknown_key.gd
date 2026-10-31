class Foo extends StructRef:
	var foo := 1

func test():
	var data: Dictionary = { "foo": 2, "unknown": true }
	var foo = Foo.new(data)
	print(foo)
