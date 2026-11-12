class_name MathManager
extends RefCounted

var rng := RandomNumberGenerator.new()

func _init() -> void:
	rng.randomize()

func generate(level: int) -> Dictionary:
	var operations: Array[String] = ["+", "-"]
	if level >= 2:
		operations.append("×")
	if level >= 3:
		operations.append("÷")
	var op := operations[rng.randi_range(0, operations.size() - 1)]
	var a: int
	var b: int
	var answer: int
	var maximum := mini(15 + level * 5, 60)
	match op:
		"+":
			a = rng.randi_range(2, maximum)
			b = rng.randi_range(2, maximum)
			answer = a + b
		"-":
			a = rng.randi_range(4, maximum)
			b = rng.randi_range(1, a)
			answer = a - b
		"×":
			var factor_max := mini(7 + level, 15)
			a = rng.randi_range(2, factor_max)
			b = rng.randi_range(2, factor_max)
			answer = a * b
		"÷":
			b = rng.randi_range(2, mini(5 + level, 12))
			answer = rng.randi_range(2, mini(6 + level, 15))
			a = b * answer
	var wrong := pedagogical_wrong(a, b, answer, op)
	return {"text": "%d %s %d = ?" % [a, op, b], "correct": answer, "wrong": wrong}


func pedagogical_wrong(a: int, b: int, answer: int, op: String) -> int:
	var candidates: Array[int] = []
	match op:
		"+":
			# Prioriza a operação oposta sem introduzir resultados negativos.
			candidates = [a - b, b - a]
		"-":
			candidates = [a + b]
		"×":
			# Uma divisão alternativa só é válida quando o resultado é inteiro.
			if b != 0 and a % b == 0:
				candidates.append(int(a / b))
			if a != 0 and b % a == 0:
				candidates.append(int(b / a))
			candidates.append(a + b)
			candidates.append(a - b)
		"÷":
			candidates = [a * b, a + b, a - b]

	for value in candidates:
		if value >= 0 and value != answer:
			return value

	# Mantém a geração anterior somente como último recurso.
	return plausible_wrong(answer, op, b)


func plausible_wrong(answer: int, op: String, operand: int) -> int:
	var candidates: Array[int] = []
	if op == "×":
		candidates = [answer - operand, answer + operand, answer - 1, answer + 1]
	else:
		var spread := maxi(2, int(abs(answer) * 0.15))
		candidates = [answer - spread, answer + spread, answer - 1, answer + 1]
	candidates.shuffle()
	for value in candidates:
		if value >= 0 and value != answer:
			return value
	return answer + 1
