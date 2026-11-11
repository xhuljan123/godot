const NUMBER = 1
type FromNumber = KeysOf[NUMBER]
type FromClass = KeysOf[Node]
type Config = Struct[{ name: String, size: int }]
type Other = Struct[{ name: String, color: String }]

func test():
	var key: KeysOf[Struct[{ a: int }]] = "b"
	print(key)
	var other: KeysOf[Other] = "color"
	var config: Config = { name = "a", size = 1 }
	print(config[other])
