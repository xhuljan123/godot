extends Node

class Foo extends Resource:
	@export var foo := 1
	@export var bar: Array[int]
	var test := ['1', '2']

func use(data: ExtractExportableVars[Foo]) -> void:
	data.➡
