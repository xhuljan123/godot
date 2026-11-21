# `InferValue[source[key]]` in a parameter type: at each call, the type of the value of `source` (a struct type, or a variable
# of a struct type) at the key passed for an earlier parameter.
type Settings = Struct[{ volume: float, name: String, tags: Array[String] }]
type Point = Struct[{ x: float, y: float }]

var foo: Struct[{ key_1: int, key_2: Array[int] }] = { key_1 = 1, key_2 = [1] }

func describe_foo(key: KeysOf[foo], value: InferValue[foo[key]]) -> String:
	return "%s = %s" % [key, value]

func describe(key: KeysOf[Settings], value: InferValue[Settings[key]]) -> String:
	return "%s = %s" % [key, value]

func axis_value(axis: KeysOf[Point], value: InferValue[Point[axis]]) -> String:
	return "%s = %s" % [axis, value]

func test():
	print(describe_foo("key_1", 5)) # value is an int.
	print(describe_foo("key_2", [2, 3])) # value is an Array[int].
	print(describe("volume", 0.5)) # value is a float.
	print(describe("name", "Bob")) # value is a String.
	print(describe("tags", ["a"])) # value is an Array[String].
	var axis: KeysOf[Point] = "y"
	print(axis_value(axis, 2.5)) # Not a constant key, but every key of Point is a float.
