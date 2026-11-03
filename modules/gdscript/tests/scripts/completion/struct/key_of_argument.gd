extends Node

type Config = Struct[{ name: String, size: int }]

func describe(key: KeyOf[Config]) -> void:
	print(key)

func _ready():
	describe(➡)
