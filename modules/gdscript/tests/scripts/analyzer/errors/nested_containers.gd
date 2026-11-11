func test():
	var b: NestedArray[Array[int]] = [[1]]
	var c: NestedArray[Array[String]] = b
	print(b is NestedArray[Array[int]])
	print(c)
