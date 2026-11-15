enum Foo { A, B }
type Values = ValuesOf[Foo]
type FromStruct = ValuesOf[Struct[{ a: int }]]
var computed = [randi()]
type FromComputed = ValuesOf[computed]

func test():
	var value: Values = 2
	print(value)
