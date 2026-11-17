class Foo extends StructRef:
	var key_1: int
	var key_2 = "Bar"

func test():
	var script: Variant = Foo
	var foo = script.new()
	print(foo)
