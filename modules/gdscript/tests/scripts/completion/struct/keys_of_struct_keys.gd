extends Node

type Foo = Struct[{ foo: int, bar: Array[String] }]

func use(raw: KeysOfStruct[Foo]) -> void:
	raw.➡
