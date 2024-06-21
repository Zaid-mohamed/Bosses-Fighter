extends PanelContainer
class_name ItemInfo

# the item that the UI shows the info about
@export var item_data : ItemData


# the nodes :

# the first texture that shows the texture of the item
@onready var item_preview: TextureRect = %ItemPreview
# the label that shows the title (the item name)
@onready var title: Label = %Title
# the second texture that shows the texture of the item
@onready var item_preview_2: TextureRect = %ItemPreview2
# the label that shows the description of the item
@onready var description: Label = %Description
# the ok button that closes the window
@onready var ok_button: Button = %OkButton

# the default scale of the window (useful in tweens)
var default_scale : Vector2

func _ready() -> void:
	# give the default scale the  value of the scale 
	default_scale = scale



func close():
	var close_tween = create_tween()
	close_tween.tween_property(self, "scale", default_scale * 1.5, 0.2)
	close_tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	await close_tween.finished
	hide()

func open():
	scale = Vector2.ZERO
	show()
	var open_tween = create_tween()
	open_tween.tween_property(self, "scale", default_scale * 1.2, 0.2)
	open_tween.tween_property(self, "scale", default_scale, 0.1)
func set_item_data(value : ItemData) -> void:
	if !value : return
	item_data = value
	item_preview.texture = item_data.texture
	item_preview_2.texture = item_data.texture
	title.text = item_data.Name
	description.text = item_data.Description
