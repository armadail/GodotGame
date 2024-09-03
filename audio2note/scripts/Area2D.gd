extends Area2D


func _physics_process(delta):
	var gravity = 100
	var direction = Vector2.DOWN * gravity
	position += direction * delta  
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass



	


func _on_body_entered(body):
	queue_free()
