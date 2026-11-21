enum Foo { KEY_1, KEY_2 }
var bar: Struct[{ key_1: int, key_2: String }]
const TEST := { test_key_1 = 1, test_key_2 = "Lorem ipsum" }

func test():
	var foo := Foo.KEY_1
	match_all foo:
		Foo.KEY_1:
			pass
	match_all foo:
		Foo.KEY_1, Foo.KEY_2:
			pass
		"KEY_3":
			pass
	var key: KeysOf[bar] = "key_1"
	match_all key:
		"key_1":
			pass
	var test_key: KeysOf[TEST] = "test_key_1"
	match_all test_key:
		"test_key_1":
			pass
		_:
			pass
	match_all Foo:
		Foo.KEY_1, Foo.KEY_2:
			pass
	match_all bar:
		"key_1", "key_2":
			pass
	var number := 1
	match_all number:
		1:
			pass
