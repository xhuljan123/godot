type NotConstant = Struct[{ a = randi() }]
type NullDefault = Struct[{ b = null }]
type WrongType = Struct[{ c: int = "x" }]
type NullForInt = Struct[{ d: int = null }]
type Foo = Struct[{ bar = 1, test: String }]

func test():
	var missing: Foo = { bar = 2 }
	var bad: Foo = { bar = "2", test = "x" }
