type Config = Struct[{ name: String, size: int }]
type Other = Struct[{ name: String, color: String }]

func foo(arg: KeyOf[Struct[{ foo: int, bar: String }]]) -> void:
	print(arg)

func returns_key() -> KeyOf[Config]:
	return "color"

func test():
	foo("baz")
	var key: KeyOf[Config] = "color"
	key = "missing"
	var other: KeyOf[Other] = "color"
	key = other
	var not_struct: KeyOf[int]
	print(key is KeyOf[Config])
	var config: Config = { name = "a", size = 1 }
	print(config[other])
