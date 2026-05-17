extends Control

@export var health_component:healthComponent
@export var fear_component:fearComponent

@export var healthBar:ui_bar
@export var fearBar:ui_bar

#TODO: Fix bars not updating

func _ready() -> void:
	health_component.connect("healthChanged", on_health_changed)
	fear_component.connect("fearChanged", on_fear_changed)
	
	fearBar.fillAmount = fearBar.maxFill
	healthBar.fillAmount = healthBar.maxFill
	
func on_health_changed(amount: int) -> void: 
	amount = amount * -1
	healthBar.fillAmount -= (amount / health_component.intital_health)
	healthBar.update()

func on_fear_changed(amount: int) -> void: 
	amount = amount * -1
	fearBar.fillAmount -= (amount / fear_component.max_fear)
	fearBar.update()
