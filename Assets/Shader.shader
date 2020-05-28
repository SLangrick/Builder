shader_type canvas_item;

uniform float strength : hint_range(0, 0.2);

void fragment(){
	
	vec2 central_uv = UV - 0.5;
	
	vec2 red_shift = central_uv.yx * sin(TIME) * strength;
	vec2 blue_shift = central_uv.yx * cos(TIME) * strength;
	
	vec4 tex = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 red_tex = texture(SCREEN_TEXTURE, SCREEN_UV + red_shift);
	vec4 blue_tex = texture(SCREEN_TEXTURE, SCREEN_UV + blue_shift);
	
	COLOR = tex;
	COLOR.r = red_tex.r;
	COLOR.b = blue_tex.b;
	8
}