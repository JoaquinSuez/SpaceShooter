extends Node2D

# movement vars
var maxSpeed = 10
var baseSpeed = 6
var currentSpeed = 6 
var speedMult = 1
var moveDir = Vector2.ZERO # v2 for move()
var playerIsMoving = false # the player is pressing left/right
var movingFor = 0 # how long the player has been moving (sec.)
var drag = 0 # drag, appllied e
var direction = -1 # current direction
var lastDirection: int # previous direction
var currentRail = 3
# shooting vars
onready var BULLET = preload("res://Bullet/Bullet.tscn")
var shootingDelay = 0.2
var currentDelay = 0

func _ready():
	position = $StartPosition.position


func _process(delta):
	move(delta)
	shoot(delta)


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
		if movingFor < 0.2:
			$AnimatedSprite.animation = "startup"
			speedMult = 0.5
		else:
			$AnimatedSprite.animation = "moving"
			speedMult = 1
	elif Input.is_action_pressed("move_right"):
		moveDir.x += 1
		direction = 1
		drag += delta
		playerIsMoving = true
		movingFor += delta
		# set animations
		$AnimatedSprite.flip_h = true
		if movingFor < 0.2:
			$AnimatedSprite.animation = "startup"
			speedMult = 0.5
		else:
			$AnimatedSprite.animation = "moving"
			speedMult = 1
	
	# check up/down to change rails and set
	if Input.is_action_just_pressed("move_up"):
		currentRail -= 1
		position = main_script.rail_list
	elif Input.is_action_just_pressed("move_down"):
		currentRail += 1
		position = main_script.get_rail(currentRail).position
	
	# check if there is no left / right input and do things
	if moveDir.x == 0:
		movingFor = 0
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
	moveDir.x *= speedMult
	moveDir.x = clamp(moveDir.x, -maxSpeed, maxSpeed)
	
	position += moveDir


func shoot(delta):
	if Input.is_action_pressed("shoot"):
		if currentDelay == 0:
			var bullet = BULLET.instance()
			bullet.direction = direction
			bullet.position = position
			bullet.speed = 700
			main_script.bullet_list.append(bullet)
			
			get_tree().root.add_child(bullet)
			currentDelay = shootingDelay
	
	currentDelay -= delta
	currentDelay = clamp(currentDelay, 0, shootingDelay)
