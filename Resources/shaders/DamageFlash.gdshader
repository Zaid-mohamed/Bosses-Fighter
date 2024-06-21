shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1,1,1,1);
uniform float flash_range : hint_range(0.0, 1.0, 0.1) = 0.0;

void fragment() {
	vec4 img = texture(TEXTURE,UV);
	vec4 flashed_img = flash_color;
	flashed_img.a = img.a;
	flashed_img = mix(img,flashed_img,flash_range);
	COLOR = flashed_img;
}
