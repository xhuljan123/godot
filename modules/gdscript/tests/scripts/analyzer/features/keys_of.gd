# `KeysOf[...]`: a `List[...]` with the names of an enum, or the keys of a struct type or of a constant dictionary.
enum FooEnum { KEY_1, KEY_2 }
const TEST := { KEY_1 = 1, KEY_2 = "foo", KEY_3 = [] }
type StructType = Struct[{ key_1: int, key_2?: float, key_3 = 1 }]
type Point = Struct[{ x: float, y: float }]

type FromEnum = KeysOf[FooEnum] # List["KEY_1", "KEY_2"]
type FromConstant = KeysOf[TEST] # List["KEY_1", "KEY_2", "KEY_3"]
type FromStruct = KeysOf[StructType] # List["key_1", "key_2", "key_3"], optional keys included.

func describe(key: FromStruct) -> String:
	return "key: " + key

func axis_value(point: Point, axis: KeysOf[Point]) -> float:
	var value: float = point[axis] # All the keys are "float", so the value is too.
	return value

func test():
	var from_enum: FromEnum = "KEY_2"
	print(from_enum)
	var from_constant: FromConstant = "KEY_3"
	print(from_constant)
	print(describe("key_2"))
	print(describe(&"key_3")) # A constant `StringName` is converted.

	var same: List["KEY_1", "KEY_2"] = from_enum
	print(same)

	var inline: KeysOf[Struct[{ a: int, b: int }]] = "b"
	print(inline)

	var from_native_enum: KeysOf[Node.ProcessMode] = "PROCESS_MODE_ALWAYS"
	print(from_native_enum)

	print(axis_value({ x = 1.5, y = 2.0 }, "y"))

	var keys: Array[KeysOf[Point]] = ["x", "y"]
	var point: Point = { x = 3.0, y = 4.0 }
	for key in keys:
		print(key, " = ", point[key])
