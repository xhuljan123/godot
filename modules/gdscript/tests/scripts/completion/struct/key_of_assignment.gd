extends Node

type Config = Struct[{ name: String, size: int }]

var key: KeyOf[Config]

func _ready():
	key = ➡
