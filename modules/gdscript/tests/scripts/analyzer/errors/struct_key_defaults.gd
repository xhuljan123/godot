type NotConstant = Struct[{ a = randi() }]
type NullDefault = Struct[{ b = null }]
type WrongType = Struct[{ c: int = "x" }]
type NullForInt = Struct[{ d: int = null }]
type Foo = Struct[{ bar = 1, test: String }]
type Inner = Struct[{ key1: int = 1 }]
type UnknownNestedKey = Struct[{ e: Inner = { key2: 1 } }]
type NotConstantNested = Struct[{ f: Inner = { key1: randi() } }]
type MissingNestedKey = Struct[{ g: Foo = {} }]

func test():
	var missing: Foo = { bar = 2 }
	var bad: Foo = { bar = "2", test = "x" }
