const External = preload("../features/type_aliases_external.notest.gd")

class Types:
	type Foo = Struct[{ bar: int }]

type Missing = Types.Foo.baz
type NotStruct = Types.Foo.bar.baz
type MissingExternal = External.Point.z

func test():
	var a: Types.Foo.bar = "text"
	print(a)
