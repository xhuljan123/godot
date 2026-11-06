extends Node

type User = Struct[{ id: int, name: String, password: String }]

func use(user: Omit[User, { password }]) -> void:
	user.➡
