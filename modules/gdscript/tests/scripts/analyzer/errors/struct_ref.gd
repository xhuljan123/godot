class Foo extends StructRef:
	var foo := 1
	var bar: bool

func test():
	var unknown := Foo.new({ foo = 1, baz = 2 })
	var wrong := Foo.new({ foo = "text" })
	var foo := Foo.new({ foo = 1 })
	foo.assign({ bar = "text" })
	var too_many := Foo.new({}, {})
