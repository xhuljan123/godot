# `DictionaryWithKeys` with int keys (like the values of an enum).
enum Tile { GRASS, WATER }
type TileCosts = DictionaryWithKeys[ValuesOf[Tile], float]

var costs: TileCosts = { Tile.GRASS: 1.0, Tile.WATER: 3.5 }
var numbers: DictionaryWithKeys[List[1, 2], String] = { 1: "one", 2: "two" }

func cost(tile: ValuesOf[Tile]) -> float:
	return costs[tile]

# An enum-typed key can only hold the values of the enum.
func cost_of(tile: Tile) -> float:
	return costs[tile]

func test():
	print(costs[Tile.GRASS] + costs[1])
	print(cost(Tile.WATER))
	print(numbers[2])
	var keys: KeysOf[TileCosts] = 1
	print(costs[keys])
	var copy: Dictionary = costs
	print(copy.size())
	var untyped = { 0: 2.0, 1: 4.0 }
	var checked: TileCosts = untyped
	print(checked[0])
	var tile := Tile.WATER
	var tile_cost := costs[tile]
	print(tile_cost)
	print(cost_of(Tile.GRASS))
