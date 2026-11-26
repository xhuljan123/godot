extends Node

class Types:
	type Foo = Struct[{ key_1: int, key_2: String, inner: Struct[{ x: float }] }]

type A = Types.Foo.➡
