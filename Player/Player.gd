extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION_DT = 300
const FRICTION_DT = 300

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(dt):
  var input_vector = Vector2.ZERO
  input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
  input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
  input_vector = input_vector.normalized()

  if input_vector != Vector2.ZERO:
    animationTree.set("parameters/idle/blend_position", input_vector)
    animationTree.set("parameters/run/blend_position", input_vector)
    velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION_DT  * dt)
  else:
    velocity = velocity.move_toward(Vector2.ZERO, FRICTION_DT  * dt)

  if velocity != Vector2.ZERO:
    animationState.travel("run")
  else:
    animationState.travel("idle")

  velocity = move_and_slide(velocity)
