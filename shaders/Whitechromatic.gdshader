shader_type canvas_item;
render_mode unshaded;

uniform int mode = 0;

uniform bool useScreen = false;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float blue_thresh = 0.1;

uniform float red_thresh = 0.1;

void fragment() {
	vec4 t = texture(TEXTURE,UV);
	if (useScreen){
		t = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE), 0.0);
	}
	float r = t.r;
	float g = t.g;
	float b = t.b;
	float a = t.a;

	
	//if ((a > 0.001 && a < 0.8) || useScreen){
		//r *= 2.0;
		//b *= 2.0;
		//a *= 2.0;
	//}
	
	
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
	
	if (b > blue_thresh && g < 0.05){
		g = b*0.25; //Add a little bit of green to make it pop.
	}
	
	COLOR = vec4(r, g, b, a);
}