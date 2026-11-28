# `Pick[StructType, { key, other }]`: the struct type with only the listed keys.
type Foo = Struct[{ foo: int, bar: String, baz = 1.5 }]
type Bar = Pick[Foo, { foo }] # Struct[{ foo: int }]

func test():
	var bar: Bar = { foo = 1 }
	var same: Struct[{ foo: int }] = bar
	print(same.foo)

	# Keys can be strings. Picked keys keep their optionality and default value.
	var with_default: Pick[Foo, { baz, "bar" }] = { bar = "x" }
	print(with_default.baz, " ", with_default.bar)

	var foo: Foo = { foo = 2, bar = "y" }
	bar = foo # A struct with more keys can be assigned (structural typing).
	print(bar.foo)

	var key: KeysOf[Bar] = "foo"
	print(key)
