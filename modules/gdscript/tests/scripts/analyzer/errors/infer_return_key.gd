type Settings = Struct[{ volume: float, title: String }]
var settings: Settings = { volume = 0.5, title = "Game" }

func get_setting(key: KeysOf[Settings]) -> Infer[settings[key]]:
	return settings[key]

func wrong_source(key: String) -> Infer[missing[key]]:
	return key

func test():
	var volume: String = get_setting("volume")
	var title: int = get_setting("title")
	print(volume, title, wrong_source("x"))
