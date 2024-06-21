shader_type canvas_item;

uniform vec4 fade_to_color : source_color = vec4(0,0,0,1);
uniform float fade_range : hint_range(0.0, 1.0, 0.1) = 0.0;

void fragment() {
	vec4 img = texture(TEXTURE,UV);
	vec4 faded_img = fade_to_color;
	faded_img.a = img.a;
	faded_img = mix(img,faded_img,fade_range);
	COLOR = faded_img;
}
