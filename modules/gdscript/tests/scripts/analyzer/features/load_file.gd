# `load_file(path)`: loads at runtime like `load()`, but a constant path must exist,
# and the result is typed like `preload()` (with the class of the resource, or as the script class).
# In a constant, the resource is loaded when the script is compiled, like with `preload()`.

const GRADIENT = load_file("res://analyzer/features/load_file_resource.notest.tres")
const LoadedScript = load_file("res://analyzer/features/load_file_script.notest.gd")

func test():
	var gradient := load_file("res://analyzer/features/load_file_resource.notest.tres") # Typed as `Gradient`.
	print(gradient.get_point_count())

	# Scenes are typed as `PackedScene`. They (and their dependencies) are only loaded at runtime.
	var scene := load_file("res://analyzer/features/load_file_scene.notest.tscn")
	print(scene.can_instantiate())

	# Scripts are typed as the script class.
	print(load_file("res://analyzer/features/load_file_script.notest.gd").VALUE)
	print(load_file("res://analyzer/features/load_file_script.notest.gd").new().greet())

	# Relative paths are prefixed with "res://", like with `load()`.
	print(load_file("analyzer/features/load_file_resource.notest.tres") == gradient)

	# A non-constant path is only checked at runtime, and the result is a `Resource`.
	var path := "res://analyzer/features/load_file_resource.notest.tres"
	var resource: Resource = load_file(path)
	print(resource == gradient)

	# Constants.
	print(GRADIENT.get_point_count(), " ", GRADIENT == gradient)
	print(LoadedScript.VALUE, " ", LoadedScript.new().greet())
	const LOCAL_GRADIENT = load_file("analyzer/features/load_file_resource.notest.tres")
	const GRADIENTS = [LOCAL_GRADIENT, load_file("res://analyzer/features/load_file_resource.notest.tres")]
	print(GRADIENTS[1] == GRADIENT)
