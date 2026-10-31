# Type aliases: `type Name = Type`, reusable everywhere a type is expected.
const External = preload("type_aliases_external.notest.gd")

type Stats = Struct[{
	hp: int,
	speed: float,
}]

type Config = Struct[{
	foo: bool,
	bar: int,
	stats: Stats,
	tags?: Array[String],
}]

type Ids = Array[int]
type Callback = Callable

type Boss = Struct[{
	...Config,
	phase: int,
	bar: String, # Overrides `bar: int` from `Config`.
}]

# `type` is only a keyword for declarations, it can still be used as a name.
var type: String = "type"

class Inner:
	func speed_of(stats: Stats) -> float:
		return stats.speed

func apply(config: Config) -> Stats:
	return config.stats

func make_ids() -> Ids:
	return [1, 2, 3]

func boss_info(boss: Boss) -> String:
	return "%s %s %d %d" % [boss.foo, boss.bar, boss.stats.hp, boss.phase]

func test():
	var config: Config = { foo = true, bar = 2, stats = { hp = 10, speed = 1.5 } }
	print(apply(config).hp)
	print(Inner.new().speed_of(config.stats))
	print(make_ids())
	print(boss_info({ foo = false, bar = "big", stats = { hp = 99, speed = 0.5 }, phase = 2 }))
	var stats_list: Array[Stats] = [{ hp = 1, speed = 1.0 }, config.stats]
	print(stats_list.size())
	var point: External.Point = { x = 1.0, y = 2.0 }
	print(point.x + point.y)
	var names: External.Names = ["a", "b"]
	print(names)
	var cb: Callback = func(): return "called"
	print(cb.call())
	var type := 5 # Local variable named `type`.
	print(type, " ", self.type)
