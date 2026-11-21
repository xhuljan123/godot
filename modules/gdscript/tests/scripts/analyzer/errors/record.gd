type Foo = Record[List["foo", "bar"], int]

func test():
	var a: Foo = { "test": 1 }
	var b: Foo = { "foo": [1] }
	var c: Record[int, int]
	var d: Record[List[1.5], int]
	print(a, b, c, d)
