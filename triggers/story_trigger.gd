extends Node2D

@export var story_flag: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.name == "EventBody":
        Signals.story_trigger.emit(story_flag)
