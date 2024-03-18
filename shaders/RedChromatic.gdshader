shader_type canvas_item;
render_mode blend_add;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

global uniform vec2 displacement;

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	float displacedAlpha = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*displacement), 0.0).a;
	
	c.r = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*displacement), 0.0).r;
	//c.g = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE), 0.0).g;
	//c.b = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*displacement*-1.0), 0.0).b;
	c.g = 0.0;
	c.b = 0.0;
	
	//if (c.r < 0.0001 && displacedAlpha > 0.001) {
	//	displacedAlpha = 0.0;
	//}
	
	c.a = displacedAlpha;
	
	//if (c.r > 0.02) {
	//	c.a = 0.5;
	//}
	
	COLOR = vec4(c.r, c.g, c.b, c.a);
}