extends CharacterBody2D

# For key detection
var hActions = 0
var vActions = 0

var dashCooldown = 0
var dashing = 0

var direction = Vector2(0,0)

# Defined movement
var speed = 40
var friction = 0.9

func _ready():
	pass

func _process(delta):
	# Key detection system
	hActions = 0
	vActions = 0
	
	var pressing = false
	if (Input.is_action_pressed("up")):
		vActions -= 1
		pressing = true
	if (Input.is_action_pressed("down")):
		vActions += 1
		pressing = true
	if (Input.is_action_pressed("right")):
		hActions += 1
		pressing = true
	if (Input.is_action_pressed("left")):
		hActions -= 1
		pressing = true
	direction = Vector2(hActions, vActions)
	
	# Dashing detection + cooldown
	if (dashing > 0):
		dashing -= delta
	else: if (dashCooldown > 0):
		dashCooldown -= delta
	
	if (Input.is_action_pressed("dash")):
		if (dashCooldown <= 0 && dashing <= 0 && pressing):
			dashCooldown = 2
			dashing = 0.2
	
	
	# Makes movement even at all angles
	if (hActions != 0 and vActions != 0):
		hActions /= sqrt(2)
		vActions /= sqrt(2)
	# Update velocity
	velocity *= friction
	velocity += Vector2(hActions, vActions) * speed * delta
	
	# add dashing to velocity
	if (dashing > 0):
		velocity += direction * speed * delta
	# Update position
	position += velocity
	move_and_slide()
	
	# mouse input
	var mouse = get_global_mouse_position()
	
	# Camera controls
	$Camera.offset += ((velocity * 4 )- $Camera.offset) / 4
