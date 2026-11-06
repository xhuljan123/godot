extends Node

class Item:
	var item_name := "item"
	func describe() -> String:
		return item_name

func pick(item: Item, fallback: Item) -> void:
	parseOptional(item, fallback).➡
