extends Task

@export var score_label: Label
@export var result: Label
@export var quote: Label
@export var threshold: int
@export var threshold_percent: float
@export var win: Array[AudioStreamPlayer]
@export var win_P: AudioStreamPlayer
@export var lose: Array[AudioStreamPlayer]
@export var lose_P: AudioStreamPlayer
@export var max_mistake: int
@export var use_percent: bool = true

@export var passed_text: String = "Тест пройден"
@export var failed_text: String = "Тест не пройден"

@export var passed_quotes: Array[String] = ["Молодец!", "Какая ты умница!", "Вы заслужили оценку!"]
@export var perfect_passed_quotes: Array[String] = ["ДА ТЫ ГЕНИЙ! 😎😎😎", "ИДЕАЛЬНЫЙ БАЛЛ! 🤩🤩🤩", "ТЫ ЗАСЛУЖИЛ ПЯТЁРКУ! 😁😁😁"]
@export var failed_quotes: Array[String] = ["Надо было готовиться", "Не повезло...", "В следующий раз сдашь"]
@export var perfect_failed_quotes: Array[String] = ["тебе ТОЧНО надо было готовиться 😑", "уууууу... 😕", "бывает 😞"]

var CONTROLLER: Controller

var max_score: int = 0
var score: int

func passed_sound():
	result.text = passed_text
	result.modulate = Color.GREEN
	quote.text = passed_quotes.pick_random()
	win.pick_random().play()

func failed_sound():
	result.text = failed_text
	result.modulate = Color.RED
	quote.text = failed_quotes.pick_random()
	lose.pick_random().play()

func mistake():
	score_label.text = "Штрафные баллы: \n" + str(-CONTROLLER.score)
	if -CONTROLLER.score < max_mistake:
		passed_sound()
	elif CONTROLLER.score == 0:
		result.text = passed_text
		result.modulate = Color.ORANGE
		quote.text = perfect_passed_quotes.pick_random()
		win_P.play()
	elif -CONTROLLER.score < max_mistake * 2 + 3:
		failed_sound()
	else:
		result.text = failed_text
		result.modulate = Color.DARK_RED
		quote.text = perfect_failed_quotes.pick_random()
		lose_P.play()

func _ready() -> void:
	CONTROLLER = get_parent() as Controller
	
	points = 0
	max_mistake = CONTROLLER.max_mistake
	threshold = CONTROLLER.threshold
	threshold_percent = CONTROLLER.threshold_percent
	use_percent = CONTROLLER.use_percent
	
	if CONTROLLER.points == -1:
		for task in CONTROLLER.tasks:
			max_score += task.points
	elif CONTROLLER.points != 0:
		max_score = CONTROLLER.points * (CONTROLLER.tasks.size() - 1)
	else:
		mistake()
		return
	
	var checker: int = int(threshold_percent * max_score) if use_percent else threshold
	
	score_label.text = "Результат: \n" + str(CONTROLLER.score) + "/" + str(max_score)
	if CONTROLLER.score >= checker and CONTROLLER.score < max_score and CONTROLLER.score > 0:
		passed_sound()
	elif CONTROLLER.score == max_score:
		result.text = passed_text
		result.modulate = Color.ORANGE
		quote.text = perfect_passed_quotes.pick_random()
		win_P.play()
	elif CONTROLLER.score > 0:
		failed_sound()
	else:
		result.text = failed_text
		result.modulate = Color.DARK_RED
		quote.text = perfect_failed_quotes.pick_random()
		lose_P.play()
