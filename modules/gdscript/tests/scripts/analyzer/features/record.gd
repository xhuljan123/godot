# `Record[Keys, Value]`: like `DictionaryWithKeys`, but every key is optional. Only the listed keys are accepted.
type Foo = Record[List["foo", "bar"], int]
enum Stat { HEALTH, MANA }

func count(values: Foo) -> int:
	var dictionary: Dictionary = values
	return dictionary.size()

func test():
	var a: Foo = {} # All the keys are optional.
	print(count(a))
	var b: Foo = { "foo": 1 }
	print(count(b))
	print(b.foo)
	var c: Foo = { "foo": 1, "bar": 2 }
	print(count(c))
	print(c.foo + c.bar)
	var python_style: Foo = { bar: 3 }
	print(python_style["bar"])
	var stats: Record[ValuesOf[Stat], float] = { Stat.MANA: 5.5 }
	print(stats[Stat.MANA])
	var key: KeysOf[Foo] = "bar"
	print(key)
	var as_struct: Struct[{ foo?: int, bar?: int }] = c
	print(as_struct.bar)
