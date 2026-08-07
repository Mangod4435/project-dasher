extends Label

var scoreManager

func _process(_delta: float) -> void:
	scoreManager = ScoreManager
	self.text = "Score: %s" % scoreManager.currentScore as String
	
