# An awaited call to a function declared with `-> Infer[...]` checks the returned value, like a call without `await`.
var settings: Struct[{ volume: float, title: String }] = { volume = 0.5, title = "Game" }

func get_wrong(key: KeysOf[settings]) -> Infer[settings[key]]:
	@warning_ignore("redundant_await")
	await null
	if key == "volume":
		return "not a float"
	return settings[key]

func test():
	var title := await get_wrong("title")
	print(title)
	var volume := await get_wrong("volume")
	print(volume)
