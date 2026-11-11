const NUMBER = 1
type FromNumber = ListFrom[NUMBER]
type FromClass = ListFrom[Node]

func test():
	var key: ListFrom[Struct[{ a: int }]] = "b"
	print(key)
