var tile_type_mapping: DictionaryWithKeys[List["1", "2"], int] = {
	"1": 1,
	"2": 2,
}

func get_tile(key: String) -> int:
	return tile_type_mapping[key]

func test():
	var test := "33"
	print(tile_type_mapping[test])
	var valid_now := "1"
	print(tile_type_mapping[valid_now])
	print(tile_type_mapping["3"])
