# `Inner.Foo.key` / `External.Foo.key`: key types of struct types declared in another class or script.
const External = preload("type_aliases_external.notest.gd")

class Types:
	type Foo = Struct[{ key_1: int, key_2: String, inner: Struct[{ x: float }] }]

type A = Types.Foo.key_1 # int
type B = Types.Foo.key_2 # String
type X = Types.Foo.inner.x # float
type PointX = External.Point.x # float

func describe(a: A, b: B) -> B:
	return "%s %d" % [b, a]

func test():
	print(describe(5, "five"))
	var x: X = 1.5
	print(x)
	var px: PointX = 2.5
	print(px)
	var y: External.Point.y = 3.5
	print(y)
	var inner: Types.Foo.inner = { x = 4.5 }
	print(inner.x)
	var a: A = 7
	var as_int: int = a
	print(as_int)
