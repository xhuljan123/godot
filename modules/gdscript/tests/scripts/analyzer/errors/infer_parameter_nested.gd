enum Bar { KEY_1, KEY_2 }

func count_values(_enum: Dictionary, map: DictionaryWithKeys[ValuesOf[Infer[_enum]], int]) -> int:
	return map.size()

func later(map: DictionaryWithKeys[KeysOf[Infer[source]], int], source: Dictionary) -> void:
	print(map, source)

func test():
	print(count_values(Bar, { 0: 1 }))
	print(count_values(Bar, { 0: 1, 1: "two" }))
	print(count_values(Bar, { 0: 1, 1: 2, 7: 3 }))
	var not_constant: Dictionary = {}
	print(count_values(not_constant, { 0: 1 }))
