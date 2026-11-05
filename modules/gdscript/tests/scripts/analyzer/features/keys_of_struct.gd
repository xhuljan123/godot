# `KeysOfStruct[StructType]`: the same keys, all with `Variant` values.
type Foo = Struct[{ foo: int, bar: Array[String] }]
type WithOptional = Struct[{ id: int, label?: String }]

class Item extends Resource:
	@export var weight := 1.0
	@export var tags: Array[StringName]

func describe(raw: KeysOfStruct[Foo]) -> String:
	return "foo=%s bar=%s" % [raw.foo, raw.bar]

func test():
	# Any value type is accepted for each key.
	print(describe({ foo = "1", bar = null }))
	print(describe({ foo = 2, bar = ["a"] }))

	var raw: KeysOfStruct[Foo] = { foo = 1, bar = [] }
	raw.foo = "now a string"
	raw.bar = 3.5
	print(raw.foo, " ", raw.bar)

	# Same as the explicit struct type.
	var same: Struct[{ foo: Variant, bar: Variant }] = raw
	print(same.size())

	# A value of the original struct type fits too.
	var typed: Foo = { foo = 5, bar = ["x"] }
	var loose: KeysOfStruct[Foo] = typed
	print(loose.foo)

	# Optional keys stay optional.
	var partial_label: KeysOfStruct[WithOptional] = { id = "abc" }
	print(partial_label.has("label"))

	# Combines with the other struct utility types.
	var from_item: KeysOfStruct[ExtractFromClass[Item]] = { weight = "heavy", tags = 0 }
	print(from_item.weight, " ", from_item.tags)
	var patch: Partial[KeysOfStruct[Foo]] = {}
	print(patch.size())
	var key: KeyOf[KeysOfStruct[Foo]] = "bar"
	print(key)
