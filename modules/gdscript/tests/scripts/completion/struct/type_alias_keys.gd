extends Node

type Stats = Struct[{ hp: int, speed: float }]
type Config = Struct[{ foo: bool, stats: Stats }]

func use(cfg: Config) -> void:
	cfg.stats.➡
