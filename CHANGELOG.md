# Changelog

This file lists all changes made on the original Godot repository

## Fork additions (xhuljan123/godot) - GDScript language extensions

These features are specific to this fork and aren't part of upstream Godot. They are all statically checked
by the GDScript analyzer, so mistakes are reported in the script editor while typing. Struct-based types are
regular `Dictionary` values at runtime, and the other types compile to their base runtime types.

Table of contents:
- [Types](#types)
  - [Struct types](#struct-types-struct)
  - [Type aliases](#type-aliases-type-name--)
  - [Struct key types](#struct-key-types-fookey)
  - [Partial and Required](#partial-and-required)
  - [Omit and Pick](#omit-and-pick)
  - [StructFromClass](#structfromclass)
  - [ExtractExportableVars](#extractexportablevars)
  - [StructToVariant](#structtovariant)
  - [List](#list)
  - [KeysOf](#keysof)
  - [ValuesOf](#valuesof)
  - [DictionaryWithKeys](#dictionarywithkeys)
  - [Record](#record)
  - [NestedArray and NestedDictionary](#nestedarray-and-nesteddictionary)
  - [Typed callables](#typed-callables-callableargsreturn)
  - [FunctionArgType](#functionargtype)
  - [TypeOf](#typeof)
  - [Infer](#infer)
  - [InferValue](#infervalue)
  - [BoundCallable](#boundcallable)
  - [self as a type](#self-as-a-type)
- [Syntax](#syntax)
  - [Optional chaining](#optional-chaining-)
  - [Block comments](#block-comments--)
- [Classes](#classes)
  - [StructRef](#structref)
- [Methods](#methods)
  - [Callable.bind_strict](#callablebind_strict)
- [Functions](#functions)
  - [inferType](#infertype)
  - [mergeObjects](#mergeobjects)
  - [parseOptional](#parseoptional)
  - [load_file](#load_file)
- [Warnings](#warnings)
  - [ENUM_MATCH_NOT_EXHAUSTIVE](#enum_match_not_exhaustive)
- [Editor support](#editor-support)

### Types

#### Struct types: `Struct[{ ... }]`

A typed object: a `Dictionary` with a known set of keys, each with its own type.

- `key: Type` is a required key.
- `key?: Type` is an optional key: it may be missing, and reading it when it's missing gives `null`.
- `key = value` is an optional key with a default value, typed as the value.
- `key: Type = value` is an optional key with an explicit type and a default value (`1` is stored as `1.0` for a `float`).
- Keys are separated by commas or line breaks. Names that aren't identifiers can be written as strings (`"display name": String`).
- `...OtherStruct` copies the keys of another struct type. Later keys override earlier ones.

```gdscript
type Foo = Struct[{
	bar = 1 # Optional, inferred as int.
	scale: float = 1 # Optional, explicit type (stored as 1.0).
	test: String # Required.
	note?: String # Optional, no default value (reads as null when missing).
}]

func _ready():
	var foo: Foo = { test = "hello" } # Lua style keys...
	var other: Foo = { test: "hi", bar: 5 } # ...or name keys (TypeScript style).
	print(foo.bar) # 1 (the default value, the key isn't added)
	foo.bar += 1 # Starts from the default value.
	foo.test = 3 # Error: "test" is a String.
	var missing: Foo = {} # Error: missing required key "test".
	var unknown: Foo = { test = "a", size = 2 } # Error: key "size" does not exist.
```

- A struct with more keys can be passed where a struct with fewer keys is expected (structural typing).
- Default values must be constant expressions. Array and dictionary defaults are copied on each read.
- Function arguments of a struct type are also checked at runtime, with an error that names the wrong key.
- Struct types can be used anywhere a type is expected: variables, arguments, return types, `Array[Struct[...]]`, `Dictionary[String, Struct[...]]`.

#### Type aliases: `type Name = ...`

Declares a reusable name for any type. `type` is only a keyword at the start of a class-level declaration, so it can still be used as a variable name elsewhere.

```gdscript
type Stats = Struct[{ hp: int, speed: float }]
type Ids = Array[int]
type Boss = Struct[{
	...Stats,
	phase: int,
}]

func spawn(stats: Stats, ids: Ids) -> Boss:
	return { hp = stats.hp, speed = stats.speed, phase = 1 }
```

Aliases of other scripts work through `class_name` or `preload()` (`Other.Stats`). Hover tooltips and argument hints show both the alias and the aliased type: `Stats (Struct[{ hp: int, speed: float }])`.

#### Struct key types: `Foo.key`

The type of a key of a struct type. It can be chained for nested struct types, and optional keys work too.

```gdscript
type Bar = Struct[{ foo: String, inner: Struct[{ x: float }] }]
type Foo = Bar.foo # String
type X = Bar.inner.x # float

var name: Foo = "Bob"
var inner: Bar.inner = { x = 2.0 }
```

#### Partial and Required

- `Partial[StructType]` makes every key optional.
- `Required[StructType]` makes every key required (default values no longer apply).
- An optional second argument lists keys to leave as they are: `Partial[StructType, { foo, bar }]`.

```gdscript
type Config = Struct[{ name: String, size: int, color?: Color }]

func update(patch: Partial[Config]) -> void: # { name?: String, size?: int, color?: Color }
	if patch.has("size"):
		print(patch.size)

var full: Required[Config] = { name = "a", size = 1, color = Color.RED } # "color" is required too.
var keep_name: Partial[Config, { name }] = { name = "only the name is required" }
```

#### Omit and Pick

- `Omit[StructType, { keys }]` is the struct type without the listed keys.
- `Pick[StructType, { keys }]` is the struct type with only the listed keys.

The remaining keys keep their type, optionality and default value. Listing a key that doesn't exist is an error.

```gdscript
type User = Struct[{ id: int, name: String, password: String, role = "guest" }]

type PublicUser = Omit[User, { password }] # Struct[{ id: int, name: String, role: String = "guest" }]
type UserName = Pick[User, { name }] # Struct[{ name: String }]

var foo: Omit[Struct[{ foo: int, bar: String }], { bar }] = { foo = 1 } # Struct[{ foo: int }]
var bar: Pick[Struct[{ foo: int, bar: String }], { foo }] = { foo = 1 } # Struct[{ foo: int }]
```

#### StructFromClass

`StructFromClass[ClassType]` converts the member variables of a GDScript class into a struct type (base class variables included). Variables with a default value become optional keys, variables without one are required, static variables are left out.

```gdscript
class Foo extends RefCounted:
	var foo := false # Optional key.
	var bar: String # Required key.
	static var ignored := 1 # Not a key.

func describe(data: StructFromClass[Foo]) -> String: # Struct[{ foo?: bool, bar: String }]
	return "foo=%s bar=%s" % [data.foo, data.bar]

func _ready():
	print(describe({ bar = "only bar" }))
```

#### ExtractExportableVars

`ExtractExportableVars[ClassType]` (previously `ExtractFromClass`) is a struct type with a required key for each `@export` variable of a GDScript class (any `@export_*` annotation except `@export_tool_button`), including inherited ones. Other variables are left out.

```gdscript
class Foo extends Resource:
	@export var foo := 1
	@export var bar: Array[int]
	var test := ["1", "2"] # Not exported: not a key.

func save_foo(data: ExtractExportableVars[Foo]) -> void: # Struct[{ foo: int, bar: Array[int] }]
	print(data.foo, data.bar)

func _ready():
	save_foo({ foo = 2, bar = [1, 2] })
	var patch: Partial[ExtractExportableVars[Foo]] = { foo = 3 }
```

#### StructToVariant

`StructToVariant[StructType]` keeps the same keys (and whether each one is optional), but every value is `Variant`. Useful for raw or unvalidated data.

```gdscript
type Foo = Struct[{ foo: int, bar: Array[String] }]

func load_foo(raw: StructToVariant[Foo]) -> void: # Struct[{ foo: Variant, bar: Variant }]
	print(raw.foo, raw.bar)

func _ready():
	load_foo({ foo = "1", bar = null })
```

#### List

`List[...]` only accepts the listed constant values, like a union of literal types in TypeScript (`'foo' | 'bar' | 1`).

```gdscript
type Foo = List["foo", "bar", 1]
type Direction = List["left", "right"]

func move(direction: Direction) -> void:
	print("moving ", direction)

func _ready():
	var bar: Foo = 1 # OK
	bar = "foo" # OK
	bar = 2 # Error: Cannot assign 2 as "Foo". Expected one of: "foo", "bar", 1.
	bar = "test" # Error.
	bar = [] # Error.
	move("left") # OK
	move("up") # Error.
	var counts: Dictionary[Direction, int] = { left = 1, right = 2 }
```

- The type is the common type of the values (`String` for `Direction`, so it can be used as a `String`), or `Variant` if they differ.
- A list with fewer values can be assigned to a list with more values. A plain value that isn't known at compile time is accepted, but it's unsafe; function arguments are checked at runtime.
- Exported `List` variables of strings or integers are shown as a dropdown in the Inspector, and code completion suggests the values.

#### KeysOf

`KeysOf[Source]` (previously `ListFrom`, which also replaces the removed `KeyOf`) creates a `List` from the names of an enum, the keys of a struct type (optional keys included), or the keys of a constant dictionary.

```gdscript
enum FooEnum { KEY_1, KEY_2 }
const TEST := { KEY_1 = 1, KEY_2 = "foo", KEY_3 = [] }
type StructType = Struct[{ key_1: int, key_2?: float, key_3 = 1 }]

type Bar = KeysOf[FooEnum] # List["KEY_1", "KEY_2"]
type Baz = KeysOf[TEST] # List["KEY_1", "KEY_2", "KEY_3"]
type Qux = KeysOf[StructType] # List["key_1", "key_2", "key_3"]

type Point = Struct[{ x: float, y: float }]

func axis_value(point: Point, axis: KeysOf[Point]) -> float:
	return point[axis] # Every key is a float, so the value is typed as float.
```

Native enums work too (`KeysOf[Node.ProcessMode]`). Using a key of a `KeysOf` type that doesn't exist in the struct being indexed is an error.

A GDScript class gives the names of its (non-static) member variables, inherited ones included (`KeysOf[MyClass]`, like `KeysOf[StructFromClass[MyClass]]`). A variable, parameter or member of a struct type or of a GDScript class gives the keys of its type (`KeysOf[foo]` with `var foo: Struct[{ ... }]` or `var foo: MyClass`).

#### ValuesOf

`ValuesOf[Source]` creates a `List` from the values of an enum, the values of a constant dictionary, or the elements of a constant array (duplicates are removed). It's the counterpart of [`KeysOf`](#keysof).

```gdscript
enum Foo { KEY_1, KEY_2 }
var test = { key_1 = 1, key_2 = 2 }
const BAR = { key_1 = 1, key_2 = ["test"] }

type BarType1 = ValuesOf[Foo] # List[0, 1]
type BarType2 = ValuesOf[test] # List[1, 2]
type BarType3 = ValuesOf[BAR] # List[1, ["test"]]

var value: BarType1 = 2 # Error: Expected one of: 0, 1.
```

- A variable (member or local) can be used when it's initialized with a constant dictionary or array literal: its initial value is used, so later changes to the variable don't change the type. `KeysOf` accepts such variables too.
- Struct types have no values, so `ValuesOf[StructType]` is an error (use [`TypeOf`](#typeof) on a struct key for its type). Objects can't be values of a `List`.
- Native enums work too (`ValuesOf[Node.ProcessMode]`).

#### DictionaryWithKeys

`DictionaryWithKeys[Keys, ValueType]` is a dictionary that must contain every key of a list of string keys, each with a value of `ValueType` (like `Record<K, V>` in TypeScript).

```gdscript
type Foo = DictionaryWithKeys[List["foo", "bar"], int]
enum Stat { HEALTH, MANA }
type Stats = DictionaryWithKeys[KeysOf[Stat], float]

var bar: Foo = { foo = 1, bar = 2 } # OK
var a: Foo = { foo = 1 } # Error: missing required key "bar".
var b: Foo = { bar = 1 } # Error: missing required key "foo".
var c: Foo = { foo = "1", bar = 2 } # Error: "foo" should be int.
var stats: Stats = { HEALTH = 10, MANA = 5.5 }
```

A plain `Dictionary[List[...], ValueType]` only limits which keys are allowed, without requiring all of them.

Keys can be strings or ints, so the values of an enum work too:

```gdscript
enum Tile { GRASS, WATER }
var costs: DictionaryWithKeys[ValuesOf[Tile], float] = { Tile.GRASS: 1.0, Tile.WATER: 3.5 }
var names: DictionaryWithKeys[List[1, 2], String] = { 1: "one", 2: "two" }
names["1"] # Error: the key 1 is an int, "1" isn't one of the keys.
```

Indexing a `DictionaryWithKeys` only accepts its keys: a constant key that isn't one of them, a variable whose initial value isn't one of them, or any other typed key (like a `String` variable or parameter, which could hold any value) is an error. Use a constant key, or type the key as a `List` or `KeysOf` of the keys. Untyped values and `for` loop keys are checked at runtime.

```gdscript
var tile_type_mapping: DictionaryWithKeys[List["1", "2"], int] = { "1": 1, "2": 2 }

func get_tile(key: KeysOf[DictionaryWithKeys[List["1", "2"], int]]) -> int:
	return tile_type_mapping[key] # OK.

func _ready():
	var test := "33"
	tile_type_mapping[test] # Error: Key "33" (the value of "test") does not exist in struct type "...".
	var name: String = get_name()
	tile_type_mapping[name] # Error: Cannot use a value of type "String" as a key of "...", which only accepts its keys ("1", "2").
```

With int keys, a key typed as an enum (a variable or parameter of type `Tile`) is accepted when every value of the enum is a key, like `ValuesOf[Tile]` keys:

```gdscript
enum Tile { GRASS, WATER }
var costs: DictionaryWithKeys[ValuesOf[Tile], float] = { Tile.GRASS: 1.0, Tile.WATER: 3.5 }

func cost_of(tile: Tile) -> float:
	return costs[tile] # OK.

func _ready():
	var tile := Tile.WATER
	var cost := costs[tile] # OK, `cost` is a float.
```

If the enum has a value that isn't a key, it's an error: `Key 2 of "Tile" does not exist in struct type "DictionaryWithKeys[List[0, 1], float]".`

#### NestedArray and NestedDictionary

`NestedArray[...]` and `NestedDictionary[...]` work like `Array` and `Dictionary`, but their element types can be typed collections. `Array` and `Dictionary` are unchanged (`Array[Array[int]]` is still an error).

```gdscript
var foo: NestedArray[Array[int]] = [[1, 2], [3]]
var bar: NestedDictionary[int, NestedDictionary[String, Array]] = { 1: { "a": [1, "x"] } }
var grid: NestedArray[NestedArray[Array[String]]] = [[["a"]]]

func _ready():
	var row: Array[int] = foo[0]
	print(foo[1][0] + 1) # 4, typed as int.
	var other: NestedArray[Array[String]] = foo # Error: the element types differ.
```

Nested literals are typed recursively. At runtime only the outer element type is checked, so `is` can't be used with nested types.

#### Typed callables: `Callable[Args][Return]`

Declares the argument types of a callable, and optionally its return type in a second pair of brackets. Assigned lambdas and functions are checked against the signature, and `call()` is checked and typed as the return type.

```gdscript
var on_hit: Callable[int, String][bool] = func(damage: int, source: String) -> bool:
	return damage > 10

var no_args: Callable[][void] = func() -> void: print("done")
var handlers: Array[Callable[int]] = []

func _ready():
	var killed: bool = on_hit.call(20, "trap")
	on_hit.call("20") # Error: argument 1 should be int.
	on_hit = func(text: String) -> bool: return true # Error: incompatible signature.
```

#### FunctionArgType

`FunctionArgType[function]` is a typed callable with the argument types of a function (like `Parameters<typeof foo>` in TypeScript). Arguments with a default value stay optional, and the return type isn't included. The function can be a function of the current class, of another class (`Other.function`) or a typed callable constant.

```gdscript
func foo(arg_1: int, arg_2 := "bar") -> String:
	return "%d %s" % [arg_1, arg_2]

type Bar = FunctionArgType[foo] # Callable[int, String]

func run(callback: Bar) -> void:
	callback.call(1) # OK, the second argument is optional.
	callback.call(1, 2) # Error: argument 2 should be "String".

func _ready():
	run(foo)
	run(func(a: int, b: String = "") -> String: return b) # Any function with compatible arguments.
	run(func(a: String) -> void: pass) # Error: parameter 1 cannot receive "int".
```

#### TypeOf

`TypeOf[value]` is the type of a variable, constant, function parameter, class member or struct key (like `typeof value` in TypeScript), so a type can be declared once and reused. The value is a name, optionally followed by members: `foo`, `node.position`, `Other.CONSTANT`, `config.key`. Local variables and parameters of the current function can be used too.

- Variables with an explicit or inferred (`:=`) type give that type; untyped variables (`var foo = 1`) give `Variant`. Constants give the type of their value.
- Struct keys give their declared type (an optional key `count?: int` gives `int`). A function gives its typed callable (`Callable[String][String]`).
- Only names and member chains are accepted (no calls, literals or operators). A type name is an error (use the type directly).
- It can be used anywhere a type is expected: variables, parameters, return types, type aliases, struct keys, `as`/`is`. At runtime it's the resolved type.

```gdscript
var foo: String = "bar"
var bar: Struct[{ key: String, count?: int }]

var a: TypeOf[foo] # String
var b: TypeOf[bar] # Struct[{ key: String, count?: int }]
var c: TypeOf[bar.key] # String
type Count = TypeOf[bar.count] # int
type Wrong = TypeOf[foo.length()] # Error: "TypeOf" expects a variable, constant, parameter or member name.

func _ready():
	a = 1 # Error: Cannot assign a value of type int to variable "a" with specified type String.
	var copy: TypeOf[b] = { key = "k" }
```

#### Record

`Record[Keys, ValueType]` is like [`DictionaryWithKeys`](#dictionarywithkeys), but every key is optional (like `Partial<Record<K, V>>` in TypeScript): a dictionary can have any of the keys, each with a value of `ValueType`, and no other key.

```gdscript
type Foo = Record[List["foo", "bar"], int]

var a: Foo = {} # OK, all the keys are optional.
var b: Foo = { "foo": 1 } # OK
var c: Foo = { "foo": 1, "bar": 2 } # OK
var d: Foo = { "test": 1 } # Error: Key "test" does not exist in struct type "Foo".
var e: Foo = { "foo": [1] } # Error: Cannot assign a value of type "Array" to key "foo" of type "int".
```

Keys can be strings or ints (`Record[ValuesOf[MyEnum], float]`), and indexing a `Record` only accepts its keys, like `DictionaryWithKeys`. Since a key may be missing, reading a value with a `List`/`KeysOf` key gives a weak type (known for completion, checked at runtime).

#### Infer

`-> Infer[param]` is a function return type that depends on the argument passed for `param`: each call is typed from its argument at the call site (like a generic `function foo<T>(arg: T): T` in TypeScript).

- An enum gives the type of its values: `foo(MyEnum)` is a `MyEnum`, also when the parameter is a `Dictionary`. Likewise, a constant struct or typed array keeps its type when passed for a plain `Dictionary` or `Array` parameter.
- A dictionary literal with name keys gives the struct type inferred from it, like with [`inferType()`](#infertype): `foo({ key_1: 1 })` is a `Struct[{ key_1: int }]`.
- An array literal whose elements share a type gives a typed array, and a lambda its full signature (`Callable[int][int]`, kept by `:=`).
- Any other argument gives its own type, whatever the declared type of the parameter (`Variant`, untyped or anything else): `foo(1)` is an `int`. An argument without a known type gives `Variant`, and a missing argument (with a default value) the type of the parameter.
- Inside the function, the return value isn't checked (any value can be returned). At each call, the compiled code checks that the returned value matches the inferred type.
- `param` must be a parameter of the function (not the rest parameter). `Infer` can't be used anywhere else than as a function return type.

```gdscript
enum Bar { KEY_1, KEY_2 }

func foo(arg: Dictionary) -> Infer[arg]:
	if arg.has("KEY_1"):
		return arg.KEY_1
	return arg

func identity(arg: Variant) -> Infer[arg]:
	return arg

func _ready():
	var a := foo(Bar) # a is a Bar.
	var b := foo({ key_1: 1 }) # b is a Struct[{ key_1: int }].
	var c := identity(1) # c is an int.
	b.key_2 = 1 # Error: "key_2" is not a key of the struct.
	c = "one" # Error: c is an int.

type Wrong = Infer[Bar] # Error: "Infer" can only be used as the return type of a function (or in a parameter type).
```

`Infer[param]` can also be used in the type of a parameter, to type it from an **earlier** argument of the same call: as the whole type (`other: Infer[value]`), or as an element type of `Array` or `Dictionary` (`values: Array[Infer[value]]`, `table: Dictionary[Infer[key], String]`).

- The argument is typed like with `-> Infer[param]` (an enum gives its value type, a dictionary literal a struct type, and so on). Element types that can't be inferred (an untyped argument) stay untyped.
- Array and dictionary literals passed for such a parameter are typed from it, at runtime too (`[1, 2]` is an `Array[int]`).
- Inside the function, `Infer[value]` is a `Variant`, and a container with an `Infer` element type is fully untyped (`Array[Infer[value]]` is an `Array`, `Dictionary[Infer[key], String]` a `Dictionary`): the check happens at each call. Like any typed parameter, a value whose type isn't known statically is only checked against the declared type (`Array`) at runtime, not its element type.
- The parameter must come before (`func foo(a: Array[Infer[b]], b)` is an error).
- `Infer` can also be nested in utility types, struct keys and callable signatures (`DictionaryWithKeys[ValuesOf[Infer[_enum]], int]`, `Struct[{ value: Infer[data] }]`). Then the whole type is resolved again at each call with the argument types. `KeysOf[Infer[a]]`/`ValuesOf[Infer[a]]` read an enum argument, a struct value, or a constant dictionary or array argument. If that fails (`ValuesOf` of a non-constant dictionary), the error is reported on the argument. An argument without a known type skips the check. Inside the function, such a parameter has a plain type: `Dictionary` for struct types, `Array`, `Callable`, or `Variant`.
- Argument hints and the script documentation show the declared type (`values: Array[Infer[value]]`).

```gdscript
func fill(value: Variant, values: Array[Infer[value]]) -> void:
	pass

func _ready():
	fill(1, [1, 2, 3]) # OK: "values" is an Array[int].
	fill(1, ["1"]) # Error: Cannot have an element of type "String" in an array of type "Array[int]".
	fill(1, 1) # Error: argument 2 should be "Array[int]" but is "int".
	fill("a", ["b"]) # OK: "values" is an Array[String].
```

```gdscript
enum Bar { KEY_1, KEY_2 }

func set_weights(_enum: Dictionary, weights: DictionaryWithKeys[KeysOf[Infer[_enum]], int]) -> void:
	pass

func _ready():
	set_weights(Bar, { KEY_1 = 1, KEY_2 = 2 }) # OK.
	set_weights(Bar, { KEY_1 = 1 }) # Error: Missing required key "KEY_2".
```

#### BoundCallable

`BoundCallable` is the type of the result of [`bind_strict()`](#callablebind_strict): a callable with all its arguments already bound, which can only be called with `call()` (or `call_deferred()`) without arguments. `BoundCallable[ReturnType]` also gives the return type.

```gdscript
func foo(arg: int) -> String:
	return "foo %d" % arg

func run(callback: BoundCallable[String]) -> String:
	return callback.call()

func _ready():
	var bar := foo.bind_strict(1) # bar is a BoundCallable[String] (kept by `:=`).
	bar.call() # Valid, returns "foo 1".
	bar.call(1) # Error: no argument can be passed to a BoundCallable.
	bar.bind(2) # Error: use call() (also for callv(), bindv(), bind_strict() and unbind()).
	run(foo.bind_strict(2))
	var not_bound: BoundCallable = func() -> void: pass # Error: only bind_strict() results are BoundCallable.
	var plain: Callable = bar # A BoundCallable can still be used as a plain Callable.
```

#### InferValue

`value: InferValue[source[key]]` types a parameter from an **earlier** parameter `key` at each call: `value` must have the type of the value of `source` at the key passed for `key` (like `function set<K extends keyof T>(key: K, value: T[K])` in TypeScript). `source` is a struct type (`Settings`, `Other.Settings`), a GDScript class (`MyClass`, or `self` for the current class), or a variable, constant or member of one of them (`foo`, `self.foo`). A class is used like [`StructFromClass`](#structfromclass): its (non-static) member variables are the keys, with their declared types.

- A constant key gives the declared type of that key: `set_value("key_1", 1)` checks `1` as an `int`, `set_value("key_2", [1])` checks `[1]` as an `Array[int]`.
- A key typed as a `List`/`KeysOf` (or an enum, for int keys) gives the type shared by all of its keys, or `Variant` if they don't share one. Any other key gives `Variant` (the key itself is checked by its own parameter type, usually `KeysOf[source]`).
- Inside the function, `value` is a `Variant`. The check happens at each call, statically.
- `InferValue` can only be used in the type of a parameter, and `key` must be a parameter that comes before it. It can be nested like `Infer` (`Array[InferValue[foo[key]]]`).

```gdscript
var foo: Struct[{ key_1: int, key_2: Array[int] }] = { key_1 = 1, key_2 = [1] }

func set_value(key: KeysOf[foo], value: InferValue[foo[key]]) -> void:
	pass

func _ready():
	set_value("key_1", 2) # OK: "value" is an int.
	set_value("key_2", [2, 3]) # OK: "value" is an Array[int].
	set_value("key_1", [2]) # Error: argument 2 should be "int" but is "Array".
	set_value("key_3", 1) # Error: "key_3" is not a key of "foo".
```

With a class:

```gdscript
class_name Foo

var a: int = 1
var b := "test"

func set_value(key: KeysOf[Foo], value: InferValue[self[key]]) -> void:
	set(key, value)

func _ready():
	set_value("a", 2) # OK: "value" is an int.
	set_value("b", "other") # OK: "value" is a String.
	set_value("a", "2") # Error: argument 2 should be "int" but is "String".
```

`self` works in static functions too, since a type annotation doesn't use the instance (see [self as a type](#self-as-a-type)).

#### self as a type

`self` can be used as a type: it's the current class (like `this` types in TypeScript). It works wherever a type or a class is expected, so the generic types work on the class they're written in without repeating its name (or without a `class_name` at all):

- `KeysOf[self]`: the names of the (non-static) member variables of the class.
- `StructFromClass[self]`, `ExtractExportableVars[self]`: the struct type of the class.
- `TypeOf[self]`: the class type (`TypeOf[self.member]` was already supported).
- `InferValue[self[key]]`: the type of the member variable passed as `key` (see [InferValue](#infervalue)).
- `Array[self]`, `DictionaryWithKeys[KeysOf[self], int]`, `-> self` and so on.

```gdscript
var a: int = 1
var b := "test"

func snapshot() -> StructFromClass[self]:
	return { a = a, b = b }

func set_value(key: KeysOf[self], value: InferValue[self[key]]) -> void:
	set(key, value)

static func describe(key: KeysOf[self], value: InferValue[self[key]]) -> String:
	return "%s = %s" % [key, value] # `self` in a type annotation works in static functions.
```

Like `StructFromClass[MyClass]` inside `MyClass`, a member variable can't be typed from the keys of its own class (`var data: StructFromClass[self]` is a cyclic reference): use it in parameters, return types, local variables and type aliases.

### Syntax

#### Optional chaining: `?.`

`a?.b`, `a?.method()` and `a?.[key]` give `null` when `a` is `null` (or a freed object), and skip the rest of the chain, including the arguments of calls.

```gdscript
var node_ref: Foo = get_node_or_null("Foo")
node_ref?.do_something() # Same as: if node_ref: node_ref.do_something()
print(node_ref?.child.value) # null if node_ref is null (the whole chain is skipped).

var list: Dictionary[String, int] = { "foo": 1, "bar": 2 }
print(list?.["foo"]) # 1
print(list?.["baz"]) # null instead of an error.

var array: Array[int] = [10, 20]
print(array?.[5]) # null instead of an out of bounds error.

var user: Struct[{ name: String, age?: int, role = "guest" }] = { name = "Bob" }
print(user?.["age"]) # null
print(user?.["role"]) # "guest" (the default value)
```

`?.` can't be used in an assignment target. A chain that can give `null` is typed as a weak type, so assigning it to a typed variable is checked at runtime.

#### Block comments: `/* */`

Comments that can span multiple lines or sit inside a line of code.

```gdscript
/*
	Multiline
	block comment.
*/
func _ready():
	var x := 6 /* inline */ / 2
```

### Classes

#### StructRef

A `RefCounted` whose script variables can be set all at once from a dictionary. If the class doesn't define `_init()`, its constructor takes a dictionary typed as `StructFromClass[ThisClass]`: variables without a default value are required keys, and variables with one are optional (they keep their default value when left out). The dictionary itself can only be left out when every variable has a default value. `assign()` updates any subset of the variables later.

Required keys are checked at compile time for dictionary literals and struct values, and at runtime for other dictionaries (`Error constructing "Foo": Missing required variable "key_1" (it has no default value).`). A class with its own `_init()` keeps its own constructor.

```gdscript
class Foo extends StructRef:
	var key_1: int
	var key_2 = "Bar"

class AllOptional extends StructRef:
	var key_1: int = 1
	var key_2 = "Bar"

func _ready():
	Foo.new() # Error: too few arguments, "key_1" is required.
	Foo.new({}) # Error: missing required key "key_1".
	Foo.new({ key_2 = "test" }) # Error: missing required key "key_1".
	Foo.new({ key_1 = "test" }) # Error: "key_1" is an int.
	var foo := Foo.new({ key_1 = 1 }) # key_2 keeps "Bar".
	foo.assign({ key_2 = "test" }) # Updates only "key_2".
	Foo.new({ key_1 = 1, baz = 1 }) # Error: "baz" isn't a variable of Foo.

	AllOptional.new() # Every variable has a default value, so the argument is optional.
	AllOptional.new({})
	AllOptional.new({ key_1 = "test" }) # Error: "key_1" is an int.
```

### Methods

#### Callable.bind_strict

`bind_strict(...)` works exactly like `bind()` at runtime, but the bound arguments are checked against the function's signature in the editor: every required argument must be bound (arguments with a default value may be left out), each one must have the right type, and extra arguments are errors. It works on function names, lambdas and typed callables; on a plain `Callable` whose signature isn't known it behaves like `bind()`.

```gdscript
func foo(arg_1: int, arg_2 := "bar") -> String:
	return "%d %s" % [arg_1, arg_2]

func _ready():
	foo.bind_strict() # Error: missing arguments.
	foo.bind_strict(1) # Valid, since arg_2 is optional.
	foo.bind_strict("1") # Error: argument 1 should be "int".
	foo.bind_strict(1, 2) # Error: argument 2 should be "String".
	foo.bind_strict(1, "bar", "foo") # Error: too many arguments.

	var text: String = foo.bind_strict(2, "baz").call() # "2 baz", typed as the return type of foo().
```

The result is a [`BoundCallable`](#boundcallable): it can only be called with `call()` without arguments (calling it with more would shift the bound arguments, like with `bind()`), and it keeps the function's return type.

### Functions

#### inferType

`inferType(value)` returns the value unchanged, typed from it:

- A dictionary literal is typed as a struct inferred from it: nested dictionaries become nested structs, and arrays whose elements share a type become typed arrays.
- A lambda (or a function name) is typed as its full signature, `Callable[Args][Return]`. Untyped parameters with a default value are typed as the default value. Without a return type annotation, the return type is inferred from the `return` statements (their common type, or `Variant` if they differ), and there is none if the function doesn't return a value.

```gdscript
var player := inferType({ name: "Bob", hp: 10, tags: ["fast"] })
# Struct[{ name: String, hp: int, tags: Array[String] }]
player.hp = "full" # Error: "hp" is an int.

var foo := inferType(func(arg1: int, arg2 = 1.0):
	return arg1 + int(arg2)
) # Callable[int, float][int]
var total: int = foo.call(1) # OK, arg2 is optional.
foo.call("1") # Error: argument 1 should be "int".

var printer := inferType(func(text: String): print(text)) # Callable[String] (no return value)
```

A variable declared with `:=` from `inferType(func ...)` keeps the signature (a `:=` variable from a plain lambda stays an untyped `Callable`).

#### mergeObjects

`mergeObjects(defaults, overrides)` returns a new dictionary with the keys of both structs (values from `overrides` win), typed as a struct with the combined keys.

```gdscript
type Config = Struct[{ name: String, size: int }]
const DEFAULT_CONFIG: Config = { name: "default", size: 1 }

func make_config(options: Partial[Config]) -> Config:
	return mergeObjects(DEFAULT_CONFIG, options)

var a: Struct[{ name: String, size: int }] = { name = "a", size = 1 }
var b: Struct[{ size: int, color: Color }] = { size = 2, color = Color.RED }
var merged := mergeObjects(a, b) # Struct[{ name: String, size: int, color: Color }]
```

Both arguments must be structs (struct-typed values or dictionary literals with name keys).

#### parseOptional

`parseOptional(value, default_value)` returns `value`, or `default_value` if `value` is `null`. With an optional struct key, the result is typed as the key's declared type, and `default_value` must match it.

```gdscript
var foo: Struct[{ bar?: int }] = {}
var bar := parseOptional(foo.bar, 1) # 1, typed as int.
var wrong := parseOptional(foo.bar, "0") # Error: argument 2 should be "int".
```

#### load_file

`load_file(path)` loads a resource like `load()`, but a constant path is checked in the editor (missing file, unknown extension) and the result is typed like `preload()`, without loading anything during analysis. It can also be used in constants.

```gdscript
var scene := load_file("res://enemy.tscn") # Typed as PackedScene.
const Enemy = load_file("res://enemy.gd") # Typed as the script class: Enemy.new()
const SHADER = load_file("res://shader.gdshader")
var missing := load_file("res://missing.tscn") # Error: File "res://missing.tscn" does not exist.
```

### Warnings

#### ENUM_MATCH_NOT_EXHAUSTIVE

A `match` on a value typed as an enum must have a branch for every value of the enum. Otherwise, the editor reports which values are missing. It's treated as an error by default; change it in **Project Settings > Debug > GDScript > Warnings > Enum Match Not Exhaustive** (`debug/gdscript/warnings/enum_match_not_exhaustive`), or silence one `match` with `@warning_ignore("enum_match_not_exhaustive")`.

- A branch without a guard that matches any value (`_` or `var x`) handles the remaining values.
- Branches with a `when` guard don't count, since the guard can fail.
- Values sharing the same number are handled together, and constant `int` patterns count too.
- For engine enums, the `*_MAX` sentinel values (like `TYPE_MAX` or `TabContainer.POSITION_MAX`) aren't required.
- Only values typed as an enum are checked (`var value: Foo`, `var value := Foo.KEY_1`, parameters, struct keys); untyped values and `int` values aren't.

```gdscript
enum Foo { KEY_1, KEY_2 }

var value: Foo

func _ready():
	match value: # OK: every value is handled.
		Foo.KEY_1:
			handle()
		Foo.KEY_2:
			handle()

	match value: # Error: "match" doesn't handle every value of the enum "Foo". Missing: KEY_2.
		Foo.KEY_1:
			handle()

	match value: # OK: "_" handles the remaining values.
		Foo.KEY_1:
			handle()
		_:
			pass
```

### Editor support

- Syntax highlighting: `type` in type alias declarations uses the keyword color (like `var` and `func`). `Struct`, `Partial`, `Required`, `Omit`, `Pick`, `StructFromClass`, `ExtractExportableVars`, `StructToVariant`, `List`, `KeysOf`, `ValuesOf`, `DictionaryWithKeys`, `Record`, `NestedArray`, `NestedDictionary`, `FunctionArgType`, `TypeOf`, `Infer` and `InferValue` use the base type color when followed by `[`. `BoundCallable` uses the base type color.
- Argument hints: `call()`, `call_deferred()` and `bind_strict()` on a callable with a known signature show its argument types.
- Code completion: type names, struct keys (in literals, after `.`, in `Foo.` types), variables and members inside `TypeOf[...]`, parameters inside `Infer[...]`, `List`/`KeysOf`/`ValuesOf` values in assignments and call arguments, members after `?.`.
- Hover tooltips, argument hints and the script documentation show the full types, including the aliased type of type aliases (`Foo (Struct[{ ... }])`), and `Infer[param]` as the return type of functions declared with it.
