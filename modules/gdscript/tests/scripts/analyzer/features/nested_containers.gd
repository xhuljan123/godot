# `NestedArray[...]` and `NestedDictionary[...]`: like `Array` and `Dictionary`, but the element types can be typed collections.
var foo: NestedArray[Array[int]]
var bar: NestedDictionary[int, NestedDictionary[String, Array]]

func sum(matrix: NestedArray[Array[int]]) -> int:
	var total := 0
	for row in matrix:
		for value in row:
			total += value
	return total

func test():
	foo = [[1, 2], [3]]
	print(sum(foo))
	var first_row: Array[int] = foo[0]
	print(first_row, " ", first_row.is_typed(), " ", foo.is_typed())
	print(foo[1][0] + 1)

	bar = { 1: { "a": [1, "x"] } }
	print(bar[1]["a"][1])
	var inner: Dictionary[String, Array] = bar[1]
	print(inner.is_typed())

	var grid: NestedArray[NestedArray[Array[String]]] = [[["a"]]]
	print(grid[0][0][0])

	# The original `Array` and `Dictionary` types are unchanged.
	var plain: Array[int] = [1]
	print(plain)
	var untyped_elements: NestedArray[Array] = [[1, "a"]]
	print(untyped_elements)
