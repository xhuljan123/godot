# `Infer[param]` in parameter types: typed from the argument passed for an earlier parameter at each call.
enum Bar { KEY_1, KEY_2 }

func fill(value: Variant, values: Array[Infer[value]]) -> int:
	return values.size()

func same(value: Variant, other: Infer[value]) -> bool:
	return value == other

func lookup(key: Variant, table: Dictionary[Infer[key], String]) -> String:
	return table.get(key, "")

func check(value: Variant, values: Array[Infer[value]]) -> bool:
	return values.is_typed() and values.get_typed_builtin() == typeof(value)

func test():
	print(fill(1, [1, 2, 3]))
	print(fill("a", ["b", "c"]))
	print(same(2, 2))
	print(same(1.5, 1)) # A constant int is converted to float, like for a float parameter.
	print(lookup(1, { 1: "one" }))
	print(check(1, [1, 2])) # The literal is an Array[int] at runtime too.
	print(fill(Bar.KEY_1, [Bar.KEY_2]))
