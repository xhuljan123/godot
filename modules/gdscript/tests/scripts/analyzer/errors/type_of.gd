var foo: String = "bar"
var bar: Struct[{ key: String }]

type FromType = TypeOf[Node]
type FromCall = TypeOf[foo.length()]
type FromLiteral = TypeOf[1]

func test():
	var text: TypeOf[foo] = 1
	var data: TypeOf[bar] = { other = 1 }
	print(text, data)
