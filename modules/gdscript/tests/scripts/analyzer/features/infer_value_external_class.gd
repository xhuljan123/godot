# `Infer[source[key]]` where the value is typed as a class from a script that only the source script depends on: a call
# can still look up members on the value.
const Source = preload("infer_value_external_class_source.notest.gd")

func test():
	var config := Source.value("config") # The Config class of the source script.
	print(config.label.to_upper())
	print(config.limits.size())
	print(Source.value("configs")[0].label)
	Source.set_value("count", Source.value("count") + 1)
	print(Source.value("count"))
