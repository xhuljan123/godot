class Settings:
	var volume: float = 1.0
	var title := "Game"

var a: int = 1

func describe(key: KeysOf[Settings], value: Infer[Settings[key]]) -> void:
	print(key, value)

func set_own(key: String, value: Infer[self[key]]) -> void:
	print(key, value)

func test():
	describe("volume", "loud")
	set_own("a", "text")
