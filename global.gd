extends Node

var map_pos = Vector2(0,0)
var money = 0
var gun_names = ["pistol", "uzi", "shotgun", "machinegun"]
var gun_costs = [0, 100, 2000, 100000]
var gun_imgs = [0, "res://assets/machinegun.jpg", "res://assets/shotgun.jpg", "res://assets/uzi.png"]
var best_owned_gun = 0
var current_gun = 0
