extends Node
class_name PlayerState
## A class to hold all of the players state chart code

## Path to player
var player : Player

func _ready():
	player = owner
