type Foo = Struct[{ bar: int }]
type Missing = Foo.baz
type NotStruct = Foo.bar.baz

func test():
	var a: Foo.bar = []
	print(a)
