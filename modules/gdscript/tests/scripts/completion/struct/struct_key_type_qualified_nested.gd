extends Node

class Types:
	type Foo = Struct[{ key_1: int, inner: Struct[{ x: float, y: float }] }]

type X = Types.Foo.inner.➡
