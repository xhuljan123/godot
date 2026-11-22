class Settings:
	var volume: float = 1.0

func describe(target: Variant, key: KeysOf[Infer[target]], value: Infer[target[key]]) -> void:
	print(target, key, value)

func later(key: String, value: Infer[target[key]], target: Variant) -> void:
	print(target, key, value)

func test():
	describe(Settings.new(), "volume", "loud")
	describe({ count = 1 }, "count", "two")
