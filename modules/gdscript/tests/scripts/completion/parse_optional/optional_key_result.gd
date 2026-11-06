extends Node

func use(options: Struct[{ label?: String }]) -> void:
	parseOptional(options.label, "").➡
