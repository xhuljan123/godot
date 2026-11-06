class Item:
	pass

func test():
	var count: int
	print(parseOptional(count, '2'))
	var ratio: float
	var amount: int = 1
	print(parseOptional(ratio, amount))
	print(parseOptional(count, null))
	var item: Item
	print(parseOptional(item, Node.new()))
	print(parseOptional(count))
	print(parseOptional(count, 1, 2))
	print(parseOptional(int, 1))
