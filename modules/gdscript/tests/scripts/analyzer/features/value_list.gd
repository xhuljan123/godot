# `List[...]`: only the listed values are accepted (like a union of literal types in TypeScript).
type Foo = List["foo", "bar", 1]
type Direction = List["left", "right"]
type Small = List[1, 2, 3]

const DEFAULT_DIRECTION: Direction = "left"

func move(direction: Direction) -> String:
	return "moving " + direction

func pick(value: Foo) -> Variant:
	return value

func test():
	var bar: Foo = 1
	print(bar)
	bar = "foo"
	print(bar)
	print(pick("bar"))
	print(move("right"))
	print(move(&"left")) # A constant `StringName` is converted.
	print(DEFAULT_DIRECTION)

	var direction: Direction = "right"
	var as_string: String = direction # The values are strings, so it's a `String`.
	print(as_string.to_upper())

	var size: Small = 2
	print(size + 1)

	var directions: Array[Direction] = ["left", "right", "left"]
	print(directions)

	# A list with fewer values can be assigned.
	var left_only: List["left"] = "left"
	direction = left_only
	print(direction)

	# A value that isn't known at compile time is accepted (unsafe). Function arguments are checked at runtime.
	var untyped = "left"
	print(move(untyped))

	var counts: Dictionary[Direction, int] = { "left": 1, right: 2 }
	print(counts)

	var chosen: Direction = "left" if directions.size() > 5 else "right"
	print(chosen)
