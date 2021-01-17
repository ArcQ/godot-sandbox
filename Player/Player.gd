extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION_DT = 300
const FRICTION_DT = 300
const ROLL_SPEED = 150

enum {
    MOVE,
    ROLL,
    ATTACK
    }

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitBox = $HitboxPivot/SwordHitBox

func _ready():
  animationTree.active = true
  swordHitBox.knockback_vector = roll_vector

# framerate is synced only after physics is processed, versus process which is called as fast as you can
func _physics_process(delta):
  match state:
    MOVE:
      move_state(delta)
    ROLL:
      roll_state(delta)
    ATTACK:
      attack_state(delta)


func move_state(delta):
  var input_vector = Vector2.ZERO
  input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
  input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
  input_vector = input_vector.normalized()

  if input_vector != Vector2.ZERO:
    roll_vector = input_vector
    swordHitBox.knockback_vector = input_vector
    animationTree.set("parameters/idle/blend_position", input_vector)
    animationTree.set("parameters/run/blend_position", input_vector)
    animationTree.set("parameters/roll/blend_position", input_vector)
    animationTree.set("parameters/attack/blend_position", input_vector)
    velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION_DT  * delta)
  else:
    velocity = velocity.move_toward(Vector2.ZERO, FRICTION_DT  * delta)

  if velocity != Vector2.ZERO:
    animationState.travel("run")
  else:
    animationState.travel("idle")

  move()

  if Input.is_action_just_pressed("roll"):
    state = ROLL

  if Input.is_action_just_pressed("attack"):
    state = ATTACK

func attack_animation_finished():
  state = MOVE

func roll_animation_finished():
  state = MOVE
  velocity = velocity * 0.8

func move():
  velocity = move_and_slide(velocity)

func roll_state(delta):
  velocity = roll_vector * ROLL_SPEED
  animationState.travel("roll")
  move()

func attack_state(delta):
  velocity = Vector2.ZERO
  animationState.travel("attack")
