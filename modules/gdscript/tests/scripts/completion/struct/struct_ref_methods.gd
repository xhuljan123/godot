extends Node

class Foo extends StructRef:
	var foo := 1

func _ready() -> void:
	var foo := Foo.new({ foo: 2 })
	foo.➡
