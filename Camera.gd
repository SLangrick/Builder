extends KinematicBody2D

const MOTION_SPEED = 300 # Pixels/second

func _physics_process(_delta):
	var motion = Vector2()
	
	motion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	motion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	motion.y *= 0.5
	motion = motion.normalized() * MOTION_SPEED
	move_and_slide(motion)
