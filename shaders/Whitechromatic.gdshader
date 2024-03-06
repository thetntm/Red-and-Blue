shader_type canvas_item;
render_mode unshaded;

uniform int mode = 0;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float blue_thresh = 0.1;

uniform float red_thresh = 0.1;

void fragment() {
	float r = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE), 0.0).r;
	float g = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE), 0.0).g;
	float b = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE), 0.0).b;
	
	r *= 2.0;
	b *= 2.0;
	
	if (b > blue_thresh && r > red_thresh){
		g = (r+b) / 1.45;
		r = g;
		b = g;
	}
	
	if (mode == 2){
		if (r < 0.0001){
			b *= 0.5;
		}
	} else if (mode == 3){
		if (b < 0.0001){
			r *= 0.5;
		}
	}
	
	COLOR = vec4(r, g, b, 1.0);
}