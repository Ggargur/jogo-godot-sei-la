extends CharacterBody2D

const GRAVITY = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var x_speed = Input.get_axis("left", "right") * get_meta("speed")
	
	self.velocity = Vector2(x_speed,self.velocity.y)
	
	if Input.is_action_just_pressed("jump") and self.is_on_floor():
		_jump()
		
	self.velocity -= Vector2(0, -GRAVITY)
	
	self.move_and_slide()


func _jump() -> void:
	self.velocity -= Vector2(0,get_meta("jump_force"))
