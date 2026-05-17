shader_type canvas_item;

uniform float percentage:hint_range(0.0,1,.01);
uniform float masked_alpha:hint_range(0,1,.01)=1;
uniform float unmasked_alpha:hint_range(0,1,.01);

uniform bool horizontal=false;
uniform bool invert=true;



void fragment() {
	vec4 main_tex=texture(TEXTURE,UV);
	COLOR.a=main_tex.a;
	
	float uvPOS=UV.x;
	float step_value=unmasked_alpha+step(uvPOS,percentage);

	COLOR.a=(main_tex.a)*step_value*masked_alpha;
}