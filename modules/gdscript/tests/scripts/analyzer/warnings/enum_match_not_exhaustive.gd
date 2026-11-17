enum Foo { KEY_1, KEY_2, KEY_3 }
enum Aliased { A = 1, B = 1, C = 2 }

func handle(value) -> void:
	print(value)

func test():
	var value := Foo.KEY_1

	# Every value is handled: no warning.
	match value:
		Foo.KEY_1:
			handle(1)
		Foo.KEY_2, Foo.KEY_3:
			handle(2)

	# Warning: values without a branch.
	match value:
		Foo.KEY_1:
			handle(1)

	# A wildcard handles the remaining values.
	match value:
		Foo.KEY_1:
			handle(1)
		_:
			handle(0)

	# So does a pattern bind.
	match value:
		var other:
			handle(other)

	# Warning: a branch with a guard can fail, so it doesn't count.
	match value:
		Foo.KEY_1, Foo.KEY_2:
			handle(1)
		_ when value == Foo.KEY_3:
			handle(3)

	# Values sharing a number are handled together.
	var aliased := Aliased.A
	match aliased:
		Aliased.B:
			handle(1)
		Aliased.C:
			handle(2)

	# Not an enum type: no warning.
	var number := 1
	match number:
		1:
			handle(1)

	# Engine enums don't require their `*_MAX` value.
	var position: TabContainer.TabPosition = TabContainer.POSITION_TOP
	match position:
		TabContainer.POSITION_TOP, TabContainer.POSITION_BOTTOM:
			handle(1)

	# Warning: engine enum with a missing value.
	match position:
		TabContainer.POSITION_TOP:
			handle(1)

	@warning_ignore("enum_match_not_exhaustive")
	match value:
		Foo.KEY_1:
			handle(1)
