extends Node

class Item:
	var item_name := "item"
	func describe() -> String:
		return item_name

func pick(maker: Callable[String][Item]) -> void:
	maker.call("sword").➡
