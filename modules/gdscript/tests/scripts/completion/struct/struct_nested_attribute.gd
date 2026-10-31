extends Node

func foo(arg: Struct[{ key1: String, inner: Struct[{ deep: float }] }]) -> void:
	arg.inner.➡
