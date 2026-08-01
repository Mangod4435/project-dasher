using Godot;
using Godot.Collections;

public partial class ScoreAndRating : Node
{
	public static ScoreAndRating instance { get; private set; }
	public Dictionary<string, int> score = new Dictionary<string, int> { { "BIG SHOT", 0 } };
	public int Rating = 0;

	public override void _EnterTree()
	{
		if (instance == null)
			instance = this;
		else
			QueueFree();
	}

	private void OnSongFinish() { }
}
