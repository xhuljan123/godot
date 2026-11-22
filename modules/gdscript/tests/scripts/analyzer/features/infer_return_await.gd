# Calls to a coroutine declared with `-> Infer[...]` are typed when awaited (and the value is checked at runtime).
var settings: Struct[{ volume: float, title: String }] = { volume = 0.5, title = "Game" }

func get_setting(key: KeysOf[settings]) -> Infer[settings[key]]:
	@warning_ignore("redundant_await")
	await null
	return settings[key]

func same(value) -> Infer[value]:
	@warning_ignore("redundant_await")
	await null
	return value

func test():
	var volume := await get_setting("volume") # A float.
	print(volume + 0.25)
	var title := await get_setting("title") # A String.
	print(title.to_upper())
	var number := await same(3) # An int.
	print(number + 1)
