extends Node

var jump_height: float = 220.0
var time_to_peak: float = 0.4
var time_to_descent: float = 0.34

var jump_velocity: float = -((2.0 * jump_height) / (time_to_peak * time_to_peak)) * time_to_peak
var jump_gravity: float = (2.0 * jump_height) / (time_to_peak * time_to_peak)
var fall_gravity: float = (2.0 * jump_height) / (time_to_descent * time_to_descent)
