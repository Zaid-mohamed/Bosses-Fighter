extends Resource
## The Resource That Store An Item With All Of It Info.
class_name ItemData

@export_group("Information")
## The Name.
@export var Name : String
## A Description
@export_multiline var Description : String
## The Graphics That Will Be Showed In The Game
@export var texture : Texture2D
## The AnimationLibrary Of This Item (All Animations of the item like "Use", "Bored")
@export var anim_library : AnimationLibrary
## Is This Item Stackable In The Inventory
@export var stackable : bool

