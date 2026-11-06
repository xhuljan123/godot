type User = Struct[{ id: int, name: String, password: String }]
type NoPassword = Omit[User, { password }]

func test():
	var with_password: NoPassword = { id = 1, name = "Bob", password = "x" }
	var missing: NoPassword = { id = 1 }
	var unknown_key: Omit[User, { email }]
	var not_a_struct: Omit[int, { id }]
	print(with_password.password)
