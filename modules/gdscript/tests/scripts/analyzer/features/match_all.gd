# `match_all key:` is a `match` that needs a branch for every key of the type of `key`: an enum, or a list of keys
# (`KeysOf[...]`, `List[...]`). It runs like `match`.
enum Foo { KEY_1, KEY_2 }
var bar: Struct[{ key_1: int, key_2: String }]
const TEST := { test_key_1 = 1, test_key_2 = "Lorem ipsum" }

func describe_foo(value: Foo) -> String:
	match_all value:
		Foo.KEY_1:
			return "first"
		Foo.KEY_2:
			return "second" # Every key returns, so the function always returns.

func describe_bar(key: KeysOf[bar]) -> String:
	match_all (key):
		"key_1":
			return "key_1 is an int"
		"key_2":
			return "key_2 is a String"

func test():
	print(describe_foo(Foo.KEY_1))
	print(describe_foo(Foo.KEY_2))
	print(describe_bar("key_2"))
	var test_key: KeysOf[TEST] = "test_key_1"
	match_all test_key:
		"test_key_1", "test_key_2" when false: # Branches with a guard don't count as handling their keys.
			print("never")
		"test_key_1":
			print("first test key")
		"test_key_2":
			print("second test key")
	var axis: List["x", "y"] = "y"
	match_all axis:
		"x", "y":
			print("an axis")
