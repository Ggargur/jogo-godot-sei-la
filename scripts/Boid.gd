extends RigidBody2D

class_name Boid

const max_force = 0.4
const max_speed = 400
const perception_radius = 1500

const alignment_mult = 0.5
const cohesion_mult = 0.5
const separation_mult = 0.5

var acceleration = Vector2()

func random_vector(max_X: float, max_Y:float) -> Vector2:
	var rng = RandomNumberGenerator.new()
	return Vector2(rng.randf() * max_X, rng.randf() * max_Y)

func get_boids(resultado: Array[Boid] = []) -> Array[Boid]:
	var boids = get_tree().get_nodes_in_group("boids")
	for filho in boids:
		if filho is Boid:
			resultado.append(filho)
	return resultado

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window_size = Window.get_focused_window().size
	position = random_vector(window_size.x, window_size.y)
	linear_velocity = random_vector(max_speed, max_speed)
	add_to_group("boids")
	
func fix_steering(steering: Vector2,total: int) -> Vector2:
	steering /= total
	steering = steering.normalized() * max_speed
	steering -= self.linear_velocity
	steering = steering.clamp(Vector2.ONE * -max_force, Vector2.ONE * max_force)
	return steering
	
func aling(boids: Array[Boid]) -> Vector2:
	var steering: Vector2 = Vector2()
	for boid in boids:
		steering += boid.linear_velocity
			
	return fix_steering(steering, boids.size())


func cohesion(boids: Array[Boid]) -> Vector2:
	var steering = Vector2()
	for boid in boids:
		steering += boid.linear_velocity
	
	steering /= boids.size()
	steering -= position
	steering = steering.normalized() * max_speed
	steering -= self.linear_velocity
	steering = steering.clamp(Vector2.ONE * -max_force, Vector2.ONE * max_force)
	return steering
	
func separation(boids: Array[Boid]) -> Vector2:
	var steering = Vector2()
	for boid in boids:
		var diff = position - boid.position
		diff /= diff.length()
		steering += diff
	
	return fix_steering(steering, boids.size())


func flock(boids = get_boids()) -> void:
		var close_boids: Array[Boid] = boids.filter(func(boid): return (boid.position - self.position).length() <= perception_radius && (boid.position - self.position).length() != 0)
		
		if close_boids.size() > 0 :
			var a = aling(close_boids) * alignment_mult
			var c = cohesion(close_boids) * cohesion_mult
			var s = separation(close_boids) * separation_mult
			
			acceleration = a + c + s	

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity += acceleration
	state.linear_velocity = state.linear_velocity.clampf(-max_speed, max_speed)

func _process(delta: float) -> void:
	flock()
