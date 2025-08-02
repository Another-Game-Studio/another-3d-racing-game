extends Node3D

@export var bird_scene: PackedScene
@export var bird_count: int = 10
@export var area_size: Vector3 = Vector3(10, 5, 10)
@export var bird_speed: float = 5.0

var birds: Array[PathFollow3D] = []

func _ready() -> void:
	var path: Path3D = $Path3D

	for i: int in bird_count:
		var follow: PathFollow3D = PathFollow3D.new()
		follow.loop = true
		follow.rotation_mode = PathFollow3D.ROTATION_XYZ
		path.add_child(follow)
		birds.append(follow)
		follow.progress_ratio = randf()

		var bird: Node3D = bird_scene.instantiate() as Node3D

		var scale: float = randf_range(1.0, 2.0)
		bird.scale = Vector3.ONE * scale

		var offset: Vector3 = Vector3(
			randf_range(-area_size.x / 2.0, area_size.x / 2.0),
			randf_range(-area_size.y / 2.0, area_size.y / 2.0),
			randf_range(-area_size.z / 2.0, area_size.z / 2.0)
		)
		bird.translate_object_local(offset)

		follow.add_child(bird)

func _process(delta: float) -> void:
	for f: PathFollow3D in birds:
		f.progress += delta * bird_speed
