extends Node

var final_score := 0
var final_correct := 0
var final_errors := 0
var final_level := 1
var game_over_reason := ""

func save_result(score: int, correct: int, errors: int, level: int, reason: String) -> void:
	final_score = score
	final_correct = correct
	final_errors = errors
	final_level = level
	game_over_reason = reason

