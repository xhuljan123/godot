# Optional chaining only skips a `null` value: a key that the struct type doesn't have, or a member that a built-in
# type doesn't have, is an error like without `?`.
type User = Struct[{ name: String, age?: int, inner?: Struct[{ id: int }] }]

func test():
	var user: User = { name = "Bob" }
	print(user?.levers)
	print(user?.["email"])
	print(user?.inner?.idd)
	var position := Vector3.ZERO
	print(position?.w)
