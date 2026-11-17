class Foo extends StructRef:
	var foo := 1
	var bar: bool

class AllOptional extends StructRef:
	var foo := 1

func test():
	var unknown := Foo.new({ foo = 1, bar = true, baz = 2 })
	var wrong := Foo.new({ foo = "text", bar = true })
	var foo := Foo.new({ foo = 1, bar = true })
	foo.assign({ bar = "text" })
	var too_many := Foo.new({ bar = true }, {})
	var other: Struct[{ test: int }] = { test = 1 }
	var from_other := Foo.new(other)
	var partial_match: Struct[{ foo: int, extra: String }] = { foo = 1, extra = "x" }
	foo.assign(partial_match)
	var no_argument := Foo.new()
	var empty := Foo.new({})
	var missing := Foo.new({ foo = 2 })
	var optional_wrong := AllOptional.new({ foo = "text" })
	print(unknown, wrong, too_many, from_other, no_argument, empty, missing, optional_wrong)
