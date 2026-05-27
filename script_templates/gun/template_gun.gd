# meta-name: Base gun
# meta-description: pew pew
# meta-default: true
# meta-space-indent: 4
extends gun

func use_item() -> void: shoot(BULLET)

func use_item_secondary() -> void: print("TODO: add a synergetic secondary")
