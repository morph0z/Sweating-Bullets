extends Control

@export var player_ref:player
@export var ammo_component:ammoHandlerComponent
@export var health_component:healthComponent
@export var fear_component:fearComponent

@export var healthBar:ui_bar
@export var fearBar:ui_bar

@export var topLeftInfo:Label
@export var gunInfo:Control
@export var gunInfoViewPort:SubViewport

func _ready() -> void:
	player_ref.held_items.connect("anyItemDropped", on_item_dropped)
	player_ref.held_items.connect("anyItemPickedUp", on_item_picked_up)
	player_ref.held_items.connect("itemSwitched", on_item_switched)
	
	on_item_dropped()
	
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

func _process(_delta: float) -> void:
	var infoText = "Speed ~ " + str(snappedf(player_ref.velocity.length(), 0.01)) + "ms⁻¹" + "\n" + "
					Ammo ~ " + str(ammo_component.ammo_amount)
	topLeftInfo.text = infoText

@onready var gunMesh:MeshInstance3D = gunInfoViewPort.get_node("GunMesh")
func on_item_dropped() -> void:
	if (player_ref.held_items.get_selected_item() == null): 
		gunMesh.mesh = PlaceholderMesh.new()
		return
	var modelMesh:Mesh = player_ref.held_items.get_selected_item().mesh.mesh
	gunMesh.mesh = modelMesh

func on_item_picked_up(pickedUpItem:item) -> void:
	var modelMesh:Mesh = pickedUpItem.mesh.mesh
	gunMesh.mesh = modelMesh

func on_item_switched() -> void:
	var modelMesh:Mesh = player_ref.held_items.get_selected_item().mesh.mesh
	print(player_ref.held_items.get_selected_item())
	gunMesh.mesh = modelMesh
