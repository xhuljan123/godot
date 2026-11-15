# `DictionaryWithKeys[...]` accepts constant keys, `List`/`KeysOf` keys, untyped values and `for` loop keys.
type Mapping = DictionaryWithKeys[List["1", "2"], int]
const FIRST = "1"

var tile_type_mapping: Mapping = {
	"1": 10,
	"2": 20,
}

func get_tile(key: KeysOf[Mapping]) -> int:
	return tile_type_mapping[key]

func test():
	print(tile_type_mapping["1"] + tile_type_mapping[FIRST])
	print(get_tile("2"))
	var key: List["1", "2"] = "2"
	print(tile_type_mapping[key])
	var total := 0
	for tile_key in tile_type_mapping:
		total += tile_type_mapping[tile_key]
	print(total)
