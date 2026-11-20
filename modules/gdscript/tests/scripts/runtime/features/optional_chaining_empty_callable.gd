# `?.` on a Callable or Signal skips it when it is empty, as an unset one is never null.

signal done

var on_enter: Callable
var on_exit: Callable = func (value: int) -> void: print("exit ", value)
var empty_signal: Signal

func test():
	on_enter?.call(1)
	on_exit?.call(2)
	print(on_enter?.call(3))

	var local: Callable
	local?.call()
	local = func () -> String: return "set"
	print(local?.call())

	empty_signal?.emit()
	done.connect(func () -> void: print("done"))
	var typed_signal: Signal = done
	typed_signal?.emit()

	var nothing = null
	print(nothing?.call())
