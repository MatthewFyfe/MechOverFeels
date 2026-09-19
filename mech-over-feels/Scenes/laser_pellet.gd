extends Area3D

var speed = 10
var timer = 0
var lifetime = 3
var owningPlayer:int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position += Vector3(speed,0,0) * delta
	var forward_dir = global_transform.basis.x.normalized()
	position += forward_dir * speed * delta
	
	timer += delta
	if(timer > lifetime):
		queue_free()


func _on_area_entered(area: Area3D) -> void:
	#print("Bullet hit" + area.name)
	queue_free()
