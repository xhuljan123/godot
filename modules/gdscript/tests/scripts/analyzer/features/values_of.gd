# `ValuesOf[Source]`: a `List[...]` of the values of an enum, a constant dictionary or array, or a variable initialized with one.
enum Foo { KEY_1, KEY_2 }
enum Flags { A = 1, B = 4 }
var data = { key_1 = 1, key_2 = 2 }
const BAR = { key_1 = 1, key_2 = ["test"] }
const SIZES = ["small", "large", "small"]

type FooValues = ValuesOf[Foo] # List[0, 1]
type FlagValues = ValuesOf[Flags] # List[1, 4]
type DataValues = ValuesOf[data] # List[1, 2]
type BarValues = ValuesOf[BAR] # List[1, ["test"]]
type Size = ValuesOf[SIZES] # List["small", "large"]

func accept(value: BarValues) -> void:
	print(value)

func test():
	var foo: FooValues = 1
	var flag: FlagValues = 4
	var number: DataValues = 2
	var size: Size = "large"
	print(foo, " ", flag, " ", number, " ", size)
	accept(1)
	accept(["test"])
	var local := { a = "x", b = "y" }
	var from_local: ValuesOf[local] = "y"
	print(from_local)
