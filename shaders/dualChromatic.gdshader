shader_type canvas_item;
render_mode blend_add;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

global uniform vec2 displacement;

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	float displacedAlpha1 = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*displacement), 0.0).a;
	float displacedAlpha2 = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*displacement * -1.0), 0.0).a;
	c.a = displacedAlpha1 + displacedAlpha2;
	
	c.r = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*displacement), 0.0).r;
	c.g = 0.0;
	c.b = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*displacement * -1.0), 0.0).r;
	
	COLOR = vec4(c.r, c.g, c.b, c.a);
}