class_name PaintingController
extends Node;

const ADJECTIVES = [
	"Astonishing", "Melancholic", "Whimsical", "Radiant", "Grotesque",
	"Serene", "Chaotic", "Majestic", "Forgotten", "Silent",
	"Eternal", "Peculiar", "Vivid", "Solemn", "Feverish",
	"Turbulent", "Enigmatic", "Tender", "Savage", "Luminous",
	"Wobbly", "Chonky", "Farty", "Derpy", "Squishy",
	"Sassy", "Wiggly", "Gloriously Stupid", "Suspiciously Damp", "Overly Confident",
];

const OBJECTS = [
	"Spark", "Whisper", "Echo", "Shadow", "Dance",
	"Dream", "Storm", "Fragment", "Reflection", "Symphony",
	"Portrait", "Silhouette", "Glimmer", "Requiem", "Descent",
	"Ascension", "Ballad", "Tapestry", "Ritual", "Ember",
	"Noodle", "Booty", "Potato", "Sock", "Blob",
	"Squiggle", "Doodle", "Fart", "Wiggle", "Cheese Wedge",
];

const NOUNS = [
	"Laziness", "Solitude", "Chaos", "Time", "Desire",
	"Madness", "Innocence", "Betrayal", "Eternity", "Silence",
	"Memory", "Sorrow", "Vanity", "Wonder", "Despair",
	"Hope", "Oblivion", "Passion", "Regret", "Twilight",
	"Bureaucracy", "Gravy", "Shenanigans", "Dad Jokes", "Procrastination",
	"Bad Decisions", "Expired Yogurt", "Monday Mornings", "Unpaid Taxes", "Wet Socks",
];

func createPainting(texture: Texture2D) -> PaintingData:
	var painting = PaintingData.new();
	painting.texture = texture;
	painting.title = generatePaintingTitle();
	painting.initialFame = Global.gameCycle.playerData.fame;
	painting.initialPrice = (painting.initialFame + 1) * 10;
	var maxPriceBonus: float = (painting.initialFame + 1) * 10 * randf_range(0.1, 3.0)
	painting.maxPrice = painting.initialPrice + int(ceil(maxPriceBonus))
	return painting;

func generatePaintingTitle() -> String:
	var adjective = ADJECTIVES[randi() % ADJECTIVES.size()]
	var object = OBJECTS[randi() % OBJECTS.size()]
	var noun = NOUNS[randi() % NOUNS.size()]
	return "%s %s of %s" % [adjective, object, noun]
