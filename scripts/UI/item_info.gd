extends PanelContainer
class_name ItemInfo


@export var item_data : ItemData

@onready var item_preview: TextureRect = %ItemPreview
@onready var title: Label = %Title
@onready var item_preview_2: TextureRect = %ItemPreview2
@onready var description: Label = %Description
@onready var ok_button: Button = %OkButton

var default_scale : Vector2
func _ready() -> void:
	default_scale = scale
	if !item_data: return
	item_preview.texture = item_data.texture
	item_preview_2.texture = item_data.texture
	title.text = item_data.Name
	description.text = item_data.Description



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
