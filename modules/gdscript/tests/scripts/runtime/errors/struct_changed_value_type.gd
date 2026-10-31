func test():
	var point: Struct[{ x: float }] = { x: 1.0 }
	var alias: Dictionary = point
	alias["x"] = "changed through an untyped reference"
	var x: float = point.x
	print(x)
