shader_type canvas_item;

uniform float blur: hint_range(0.0, 2.0);
uniform float darken: hint_range(0.0, 5.0);

void fragment() {
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur).rgb / (darken + 1.0);
}
