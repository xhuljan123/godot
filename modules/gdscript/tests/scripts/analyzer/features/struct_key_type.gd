# `Foo.key`: the type of a key of a struct type (like `Foo["key"]` in TypeScript).
type Foo = Struct[{ bar: int, name?: String, inner: Struct[{ x: float }] }]
type Bar = Foo.bar # int
type Name = Foo.name # String (optional keys too)
type X = Foo.inner.x # float (nested struct types)

func double(value: Bar) -> Bar:
	return value * 2

func test():
	var bar: Bar = 21
	print(double(bar))
	var name: Name = "Bob"
	print(name)
	var x: X = 1.5
	print(x)
	var inner: Foo.inner = { x = 2.0 }
	print(inner.x)
	var as_int: int = bar
	print(as_int)
