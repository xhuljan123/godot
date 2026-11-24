# Struct types are exact: a struct with keys that the expected type doesn't have is an error.
type User = Struct[{ id: int, name: String, password: String }]
type PublicUser = Omit[User, { password }]
type Small = Struct[{ id: int, name: String }]
type WithOptional = Struct[{ key_1: int, key_2: int, extra?: int }]
type Nested = Struct[{ inner: Struct[{ x: int, y: int }] }]
type NestedTarget = Struct[{ inner: Struct[{ x: int }] }]

func bar(arg: Struct[{ key_1: int, key_2: int, key_3?: int }]) -> void:
	print(arg)

func to_small(user: User) -> Small:
	return user

func show(user: PublicUser) -> void:
	print(user)

func test():
	var foo: Struct[{ key_1: int, key_2: int, key_3: int, key_4: int }] = { key_1 = 1, key_2 = 2, key_3 = 3, key_4 = 4 }
	bar(foo)
	var with_optional: WithOptional = { key_1 = 1, key_2 = 2 }
	bar(with_optional)
	var user: User = { id = 1, name = "Bob", password = "secret" }
	show(user)
	var small: Small = user
	small = user
	var nested: Nested = { inner = { x = 1, y = 2 } }
	var nested_target: NestedTarget = nested
	print(small, nested_target)
