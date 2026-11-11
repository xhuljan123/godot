type Foo = List["foo", "bar", 1]
type Direction = List["left", "right"]

func move(direction: Direction) -> void:
	print(direction)

func returns_direction() -> Direction:
	return "up"

func test():
	var a: Foo = 2
	var b: Foo = "test"
	var c: Foo = []
	move("down")
	var direction: Direction = "left"
	var other: List["left", "up"] = "up"
	direction = other
	var number: Direction = 1
	print(direction is Direction)
	var duplicate: List[1, 1]
	print(a, b, c, number, duplicate)
