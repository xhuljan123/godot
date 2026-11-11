# `DictionaryWithKeys[Keys, Value]`: a dictionary that must have all the keys of the list, with values of the given type.
type Foo = DictionaryWithKeys[List["foo", "bar"], int]
enum Stat { HEALTH, MANA }
type Stats = DictionaryWithKeys[KeysOf[Stat], float]

func total(values: Foo) -> int:
	return values.foo + values["bar"]

func test():
	var bar: Foo = { foo = 1, bar = 2 }
	print(total(bar))
	var python_style: Foo = { foo: 3, bar: 4 }
	print(total(python_style))
	var stats: Stats = { HEALTH = 10, MANA = 5.5 }
	print(stats.HEALTH + stats.MANA)
	var as_struct: Struct[{ foo: int }] = bar
	print(as_struct.foo)
	var dictionary: Dictionary = bar
	print(dictionary.size())
