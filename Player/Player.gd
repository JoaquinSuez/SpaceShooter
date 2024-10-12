extends Node2D

# movement vars
export var maxSpeed: float = 0
export var baseSpeed: float = 0
var currentSpeed = 6 
var moveDir = Vector2.ZERO # v2 for move()
var playerIsMoving = false # the player is pressing left/right
var movingFor = 0 # how long the player has been moving (sec.)
var drag = 0 # drag, appllied e
var direction: int = 0 # current direction
var lastDirection: int # previous direction

func _ready():
	position = $StartPosition.position


func _process(delta):
	move(delta)


func move(delta):	
	# reset variables
	moveDir = Vector2.ZERO 
	playerIsMoving = false
	lastDirection = direction
	
	# check left/right input and do things
	if Input.is_action_pressed("move_left"):
		moveDir.x -= 1
		direction = -1
		drag -= delta
		playerIsMoving = true
		movingFor += delta
		# set animations
		$AnimatedSprite.flip_h = false
		if movingFor < 0.4:
			$AnimatedSprite.animation = "startup"
		else:
			$AnimatedSprite.animation = "moving"
	elif Input.is_action_pressed("move_right"):
		moveDir.x += 1
		direction = 1
		drag += delta
		playerIsMoving = true
		movingFor += delta
		# set animations
		$AnimatedSprite.flip_h = true
		if movingFor < 0.4:
			$AnimatedSprite.animation = "startup"
		else:
			$AnimatedSprite.animation = "moving"
	
	# check if there is no left / right input and do things
	if moveDir.x == 0:
		movingFor = 0
		direction = 0
		if drag < 0:
			drag += delta / 2
		if drag > 0:
			drag -= delta / 2
		# set animations
		$AnimatedSprite.animation = "idle"
	
	# check if direction changed from last
	# frame and do things
	if direction != lastDirection:
		moveDir = Vector2.ZERO
		movingFor = 0
	
	drag = clamp(drag, -1, 1)
	
	moveDir = moveDir.normalized()
	currentSpeed = baseSpeed * (1 + movingFor / 3)
	moveDir.x = moveDir.x * currentSpeed + drag
	moveDir.x = clamp(moveDir.x, -maxSpeed, maxSpeed)
	
	position += moveDir
