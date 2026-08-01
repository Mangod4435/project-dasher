using Godot;
using Godot.Collections;

public partial class ScoreAndRating : Node
{
	public static ScoreAndRating instance { get; private set; }

	public Dictionary<string, int> score = new Dictionary<string, int> { { "BIG SHOT", 0 } };
	public int Rating = 0;

	public override void _Ready() => instance = this;

	void OnSongFinish(string song, int score)
	{
		if (this.score.ContainsKey(song) && score > this.score[song])
			Rating += (score - this.score[song]) * 10;
	}
}
