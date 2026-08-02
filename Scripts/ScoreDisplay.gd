extends Label

var scoreManager

func _process(delta: float) -> void:
	scoreManager = ScoreManager
	self.text = "Score: %s" % scoreManager.currentScore as String
	
