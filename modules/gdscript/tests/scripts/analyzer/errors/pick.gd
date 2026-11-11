type Foo = Struct[{ foo: int, bar: String }]
type Bar = Pick[Foo, { foo }]

func test():
	var bar: Bar = { foo = 1, bar = "x" }
	var unknown: Pick[Foo, { qux }]
	var not_a_struct: Pick[int, { foo }]
	print(bar.bar)
