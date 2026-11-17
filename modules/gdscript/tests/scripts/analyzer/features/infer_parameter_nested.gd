# `Infer[param]` nested in utility types of a parameter type: the whole type is resolved again at each call.
enum Bar { KEY_1, KEY_2 }
enum Other { A = 5 }

func count_values(_enum: Dictionary, map: DictionaryWithKeys[ValuesOf[Infer[_enum]], int]) -> int:
	return map.size()

func count_names(_enum: Dictionary, map: DictionaryWithKeys[KeysOf[Infer[_enum]], int]) -> int:
	return map.size()

func make(data: Variant, extra: Struct[{ value: Infer[data] }]) -> Variant:
	return extra.value

func test():
	print(count_values(Bar, { 0: 1, 1: 2 }))
	print(count_values(Other, { 5: 1 }))
	print(count_names(Bar, { KEY_1 = 1, KEY_2 = 2 }))
	print(make(1, { value = 2 }))
	const SETTINGS = { "volume": 1, "music": 2 }
	print(count_names(SETTINGS, { volume = 3, music = 4 }))
