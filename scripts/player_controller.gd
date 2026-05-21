extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	const max_velocity = Vector2(100,1000)
	var drag = -self.linear_velocity * 0.03	
	var x_speed = Input.get_axis("left", "right") * get_meta("speed")
	if Input.is_action_just_pressed("jump"):
		_jump()
	
	var vel = Vector2(x_speed,0) + drag
	vel = vel.clamp(-max_velocity, max_velocity)
	self.apply_impulse(vel)


func _jump() -> void:
	self.linear_velocity -= Vector2(0,get_meta("jump_force"))
