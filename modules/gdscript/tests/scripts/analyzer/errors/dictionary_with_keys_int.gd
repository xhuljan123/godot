enum Tile { GRASS, WATER, LAVA }
var numbers: DictionaryWithKeys[List[1, 2], String] = { 1: "one", 3: "three" }

func test():
	print(numbers[5])
	print(numbers["1"])
	var index := 7
	print(numbers[index])
	var wrong: DictionaryWithKeys[List[1, 2], int] = { 1: 1, 2: "two" }
	print(wrong)
	var tile := Tile.GRASS
	var costs: DictionaryWithKeys[List[0, 1], float] = { 0: 1.0, 1: 2.0 }
	print(costs[tile])
