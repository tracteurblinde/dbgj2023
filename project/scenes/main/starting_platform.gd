@tool
extends Node3D

enum Banner {
	DawnGuard = 0,
	AlphaFlight = 1,
	NightWatch = 2,
	Zeta = 3
}

@export var banner : Banner = Banner.DawnGuard:
	set = set_banner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#set_banner(banner)

func set_banner(value):
	banner = value
	$Banners/DawnguardBanner.visible = value == Banner.DawnGuard
	$Banners/AlphaflightBanner.visible = value == Banner.AlphaFlight
	$Banners/NightwatchBanner.visible = value == Banner.NightWatch
	$Banners/ZetaFlag.visible = value == Banner.Zeta

