extends Node

var currentSong: String
var currentScore: int
var Rating: int
var HighScore: Dictionary[String, int] = {
	"placeholder": 0
}

func OnSongFinish(song: String, score: int):
	if (HighScore[song] < currentScore):
		Rating += (score - HighScore[song]) * 10
