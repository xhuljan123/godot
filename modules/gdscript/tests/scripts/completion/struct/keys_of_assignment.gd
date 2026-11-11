extends Node

type Config = Struct[{ name: String, size: int }]

var key: KeysOf[Config]

func _ready():
	key = ➡
