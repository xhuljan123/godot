# `ListFrom[...]`: a `List[...]` with the names of an enum, or the keys of a struct type or of a constant dictionary.
enum FooEnum { KEY_1, KEY_2 }
const TEST := { KEY_1 = 1, KEY_2 = "foo", KEY_3 = [] }
type StructType = Struct[{ key_1: int, key_2?: float, key_3 = 1 }]

type FromEnum = ListFrom[FooEnum] # List["KEY_1", "KEY_2"]
type FromConstant = ListFrom[TEST] # List["KEY_1", "KEY_2", "KEY_3"]
type FromStruct = ListFrom[StructType] # List["key_1", "key_2", "key_3"], optional keys included.

func describe(key: FromStruct) -> String:
	return "key: " + key

func test():
	var from_enum: FromEnum = "KEY_2"
	print(from_enum)
	var from_constant: FromConstant = "KEY_3"
	print(from_constant)
	print(describe("key_2"))
	print(describe("key_3"))

	var same: List["KEY_1", "KEY_2"] = from_enum
	print(same)

	var inline: ListFrom[Struct[{ a: int, b: int }]] = "b"
	print(inline)

	var from_native_enum: ListFrom[Node.ProcessMode] = "PROCESS_MODE_ALWAYS"
	print(from_native_enum)
