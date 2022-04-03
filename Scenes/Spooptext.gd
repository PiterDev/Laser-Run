extends RichTextLabel

var text_choices: Array = [
    "RUN.",
    "GO",
    "ITS CLOSE",
    "HELP",
    "DONT LOOK BACK"
]

func rand_num(from: int, to:int) -> int:
    return int(rand_range(from, to))

func _ready() -> void:
    randomize()
    set_rotation(rand_range(-80, 80))
    print(get_rotation())
    bbcode_text = "[shake rate=10 level=30]" + text_choices[rand_num(0, len(text_choices))] + "[/shake]"