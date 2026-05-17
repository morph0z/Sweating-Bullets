extends Control

@export var player_ref:player
@export var ammo_component:ammoHandlerComponent
@export var health_component:healthComponent
@export var fear_component:fearComponent

@export var healthBar:ui_bar
@export var fearBar:ui_bar

@export var topLeftInfo:Label
@export var gunInfo:Control

func _ready() -> void:
	health_component.connect("healthChanged", on_health_changed)
	fear_component.connect("fearChanged", on_fear_changed)
	
	fearBar.fillAmount = fearBar.maxFill
	healthBar.fillAmount = healthBar.maxFill
	
func on_health_changed(amount: int) -> void: 
	amount = amount * -1
	healthBar.lastAmount = healthBar.fillAmount
	healthBar.fillAmount -= (amount / health_component.intital_health)
	healthBar.update()

func on_fear_changed(amount: int) -> void: 
	amount = amount * -1
	fearBar.lastAmount = fearBar.fillAmount
	fearBar.fillAmount -= (amount / fear_component.max_fear)
	fearBar.update()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	topLeftInfo.text = "Speed ~ " + str(snappedf(player_ref.velocity.length(), 0.01)) + "ms⁻¹" + "\n" + "
						Ammo ~ " + str(ammo_component.ammo_amount)
	#var gunMesh:MeshInstance2D = gunInfo.get_node("GunMesh")
	#var modelMesh:Mesh = player_ref.held_items.get_selected_item().mesh.mesh
	#var viewMaterial:Material = preload("uid://dcxi5gqco761y")
	#modelMesh.surface_set_material(0, viewMaterial)
	#gunMesh.mesh = modelMesh
