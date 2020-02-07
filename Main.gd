extends Node2D

var eFieldStrength = 1
var bFieldStrength = 0.01
var velocityMin = 90
var velocityMax = 110
var timer = 0.5
var filterLocation = 800
var filterWidth = 32
var mass_spectrometer = true

var particle = preload("res://Particle.tscn")

func _ready():
	randomize()
	_emit()
	$Control/MainVBox/MainContainer/EField/IndividualVBox/HBox/Label.text = String(eFieldStrength).pad_decimals(2)
	$Control/MainVBox/MainContainer/BField/IndividualVBox/HBox/Label.text = String(bFieldStrength).pad_decimals(3)
	$Control/MainVBox/MainContainer/MinVelocity/IndividualVBox/HBox/Label.text = String(velocityMin).pad_decimals(0)
	$Control/MainVBox/MainContainer/MaxVelocity/IndividualVBox/HBox/Label.text = String(velocityMax).pad_decimals(0)
	$Control/MainVBox/MainContainer/Timer/IndividualVBox/HBox/Label.text = String(timer).pad_decimals(1)

func _emit():
	
	var particleNode = particle.instance()
	particleNode.movementVector = Vector2(rand_range(velocityMin, velocityMax), 0)
	add_child(particleNode)
	yield(get_tree().create_timer(timer), "timeout")
	_emit()



func _on_timer_value_changed(value):
	timer = value
	
	$Control/MainVBox/MainContainer/Timer/IndividualVBox/HBox/Label.text = String(value).pad_decimals(1)


func _on_maxVelocity_value_changed(value):
	if (value < velocityMin):
		$Control/MainVBox/MainContainer/MinVelocity/IndividualVBox/Label.set('custom_colors/font_color', Color(1,0,0))
	else: 
		$Control/MainVBox/MainContainer/MinVelocity/IndividualVBox/Label.set('custom_colors/font_color', Color(1,1,1))
		velocityMax = value
	
	$Control/MainVBox/MainContainer/MaxVelocity/IndividualVBox/HBox/Label.text = String(value).pad_decimals(0)


func _on_minVelocity_value_changed(value):
	if (value > velocityMax):
		$Control/MainVBox/MainContainer/MinVelocity/IndividualVBox/Label.set('custom_colors/font_color', Color(1,0,0))
	else: 
		$Control/MainVBox/MainContainer/MinVelocity/IndividualVBox/Label.set('custom_colors/font_color', Color(1,1,1))
		velocityMin = value
	
	$Control/MainVBox/MainContainer/MinVelocity/IndividualVBox/HBox/Label.text = String(value).pad_decimals(0)


func _on_BField_value_changed(value):
	bFieldStrength = value
	
	$Control/MainVBox/MainContainer/BField/IndividualVBox/HBox/Label.text = String(value).pad_decimals(3)


func _on_EField_value_changed(value):
	eFieldStrength = value
	
	$Control/MainVBox/MainContainer/EField/IndividualVBox/HBox/Label.text = String(value).pad_decimals(2)


func _on_filterLocation_value_changed(value):
	filterLocation = value
	
	$Control/MainVBox/MainContainer/FilterLocation/IndividualVBox/HBox/Label.text = String(value).pad_decimals(0)
	update()


func _on_filterWidth_value_changed(value):
	filterWidth = value
	
	$Control/MainVBox/MainContainer/FilterWidth/IndividualVBox/HBox/Label.text = String(value).pad_decimals(1)
	update()

func _draw():
	draw_line(Vector2(filterLocation, 50), Vector2(filterLocation, 450 - filterWidth / 2), Color(0.5, 0.5, 0.5))
	draw_line(Vector2(filterLocation, 850), Vector2(filterLocation, 450 + filterWidth / 2), Color(0.5, 0.5, 0.5))


func _on_HideButton_pressed():
	$Control/MainVBox/MainContainer.visible = !$Control/MainVBox/MainContainer.visible
	if $Control/MainVBox/MainContainer.visible:
		$Control/MainVBox/HideButton.text = "Hide Settings"
	else:
		$Control/MainVBox/HideButton.text = "Show Settings"

func _on_CheckBox_toggled(val):
	mass_spectrometer = val