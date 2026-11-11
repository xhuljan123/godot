# `Omit[StructType, { key, other }]`: the struct type without the listed keys.
type User = Struct[{ id: int, name: String, password: String, role = "guest", note?: String }]
type PublicUser = Omit[User, { password }]

func show(user: Omit[User, { id, password }]) -> String:
	return "%s (%s)" % [user.name, user.role]

func test():
	var user: User = { id = 1, name = "Bob", password = "secret" }
	print(show(user)) # A struct with more keys can be passed (structural typing).

	var public: PublicUser = { id = 2, name = "Ann" } # `password` isn't required anymore.
	print(public.id, " ", public.role) # Default values are kept.

	# Same as the explicit struct type.
	var only_foo: Omit[Struct[{ foo: int, bar: String }], { bar }] = { foo = 1 }
	var same: Struct[{ foo: int }] = only_foo
	print(same.foo)

	# Keys can be strings, and every key can be omitted.
	var nothing: Omit[Struct[{ a: int, "b-c": int }], { a, "b-c" }] = {}
	print(nothing.size())

	# Works with the other struct utility types.
	var key: KeysOf[Omit[User, { password, note }]] = "role"
	print(key)
	var patch: Partial[Omit[User, { id }]] = { name = "Eve" }
	print(patch.name)
