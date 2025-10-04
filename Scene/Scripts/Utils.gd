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

# ---------------- Time ----------------
static func get_time_info(time: int, start_year: int = 2025, start_age: int = 18) -> Dictionary:
	var year = start_year + int(time / 12)
	var month = (time % 12) + 1

	var age_increase = year - start_year
	var age = start_age + age_increase
	if age > 80:
		age = 18 + ((age - 18) % (80 - 18 + 1))

	return {
		"month": month,
		"year": year,
		"age": age
	}
	
static func get_month_name(month: int) -> String:
	var names = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun",
				 "Jul", "Ago", "Set", "Out", "Nov", "Dez"]
	if month >= 1 and month <= 12:
		return names[month - 1]
	return "Desconhecido"
