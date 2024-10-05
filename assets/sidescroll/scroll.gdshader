shader_type canvas_item;

uniform float scroll_speed;

void fragment() {
	vec2 u = UV;
	u.x += scroll_speed * TIME;
	vec4 col = texture(TEXTURE, u);
	COLOR = col;
}