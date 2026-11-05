type Foo = Struct[{ foo: int, bar: Array[String] }]
type RawFoo = StructToVariant[Foo]

class Item extends Resource:
	@export var weight := 1.0

func test():
	var missing: RawFoo = { foo = 1 }
	var unknown: RawFoo = { foo = 1, bar = 2, baz = 3 }
	var not_a_struct: StructToVariant[int]
	var a_class: StructToVariant[Item]
