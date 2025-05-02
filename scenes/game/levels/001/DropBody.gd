extends RigidBody2D

func _ready():
	contact_monitor = true
	max_contacts_reported = 1

func _integrate_forces(state: PhysicsDirectBodyState2D):
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		if collider and collider.name == "TileMap":
			queue_free()
