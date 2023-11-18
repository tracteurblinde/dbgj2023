@tool
extends Node3D

signal player_entered(node: Node3D)
var has_player_entered := false

enum Banner { DawnGuard = 0, AlphaFlight = 1, NightWatch = 2, Zeta = 3, Omega = 4 }

@export var banner: Banner = Banner.Omega:
	set = set_banner


# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		$AnimationPlayer.play("raise_flag", 0.0, false)
		$AnimationPlayer.advance(0)
		$AnimationPlayer.stop()
		$Banners.visible = false
	else:
		$Banners.visible = true
		set_banner(banner)
		$AnimationPlayer.play("raise_flag")


func set_banner(value):
	banner = value
	$Banners/DawnguardBanner.visible = value == Banner.DawnGuard
	$Banners/AlphaflightBanner.visible = value == Banner.AlphaFlight
	$Banners/NightwatchBanner.visible = value == Banner.NightWatch
	$Banners/ZetaFlag.visible = value == Banner.Zeta
	$Banners/OmegaBanner.visible = value == Banner.Omega


func _on_area_3d_body_entered(_body: Node):
	if not has_player_entered:
		has_player_entered = true
		$AnimationPlayer.play("raise_flag")
		emit_signal("player_entered", self)
