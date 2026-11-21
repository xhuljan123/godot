# `self` as a type: the current class. Works in `TypeOf`, `KeysOf`, `StructFromClass`, `InferValue` and any other type argument,
# also in static functions (a type annotation doesn't use the instance).
var a: int = 1
var b := "test"

func key_names() -> Array[KeysOf[self]]:
	return ["a", "b"]

func snapshot() -> StructFromClass[self]:
	return { a = a, b = b }

func same(other: TypeOf[self]) -> bool:
	return other == self

func set_value(key: KeysOf[self], value: InferValue[self[key]]) -> String:
	set(key, value)
	return "%s = %s" % [key, get(key)]

static func describe(key: KeysOf[self], value: InferValue[self[key]]) -> String:
	return "%s = %s" % [key, value]

func test():
	print(key_names())
	var data := snapshot()
	print(data.a, " ", data.b)
	print(same(self))
	print(set_value("a", 2)) # value is an int.
	print(describe("b", "static")) # value is a String.
	var key: KeysOf[self] = "b"
	print(key)
