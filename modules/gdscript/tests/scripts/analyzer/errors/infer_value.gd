type Settings = Struct[{ volume: float, name: String }]
var count := 0

func describe(key: KeysOf[Settings], value: Infer[Settings[key]]) -> void:
	print(key, value)

func later(value: Infer[Settings[key]], key: KeysOf[Settings]) -> void:
	print(key, value)

func not_struct(key: String, value: Infer[count[key]]) -> void:
	print(key, value)

func test():
	var wrong: Infer[Settings["volume"]]
	describe("volume", 0.5)
	describe("name", 1)
	describe("volume", "loud")
	print(wrong)
