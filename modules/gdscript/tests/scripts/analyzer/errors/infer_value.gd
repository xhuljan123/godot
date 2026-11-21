type Settings = Struct[{ volume: float, name: String }]
var count := 0

func describe(key: KeysOf[Settings], value: InferValue[Settings[key]]) -> void:
	print(key, value)

func later(value: InferValue[Settings[key]], key: KeysOf[Settings]) -> void:
	print(key, value)

func not_struct(key: String, value: InferValue[count[key]]) -> void:
	print(key, value)

func test():
	var wrong: InferValue[Settings["volume"]]
	describe("volume", 0.5)
	describe("name", 1)
	describe("volume", "loud")
	print(wrong)
