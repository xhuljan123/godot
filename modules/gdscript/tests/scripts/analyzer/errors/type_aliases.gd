type Config = Struct[{ foo: bool, bar: int }]
type Loop = Struct[{ next: Loop }]
type A = Struct[{ b: B }]
type B = Struct[{ a: A }]
type NotAStruct = Struct[{ ...Ids, x: int }]
type Ids = Array[int]

func test():
	var config: Config = { foo = true }
	var wrong: Config = { foo = true, bar = "text" }
	var value = Config
	var unknown: UnknownAlias
