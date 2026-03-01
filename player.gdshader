shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float amplitude = 0.0001;
uniform float frequency = 10.0;
uniform float speed = 2.0;

void fragment() {
	vec2 uv = SCREEN_UV;
	uv.y += sin(uv.x * frequency + TIME * speed) * amplitude;
	COLOR = texture(SCREEN_TEXTURE, uv);
}