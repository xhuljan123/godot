type Foo = DictionaryWithKeys[List["foo", "bar"], int]

func test():
	var a: Foo = { foo = 1 }
	var b: Foo = { bar = 1 }
	var c: Foo = { foo = "1", bar = 2 }
	var d: DictionaryWithKeys[List[1, 2], int]
	var e: DictionaryWithKeys[int, int]
	print(a, b, c, d, e)
