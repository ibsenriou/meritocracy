extends Node

# ---------------- Formatação ----------------
static func format_money(value: int) -> String:
	## Recebe um valor inteiro e retorna uma String formatada com 
	## o valor abreviado por MIL ou MILHÃO 
	##
	if value >= 1_000_000:
		var result = value / 1_000_000.0
		var s = str(round(result * 10) / 10.0)
		s = s.rstrip("0").rstrip(".")
		return s + "kk"
	elif value >= 1_000:
		var result = value / 1_000.0
		var s = str(round(result * 10) / 10.0)
		s = s.rstrip("0").rstrip(".")
		return s + "k"
	else:
		return str(value)
