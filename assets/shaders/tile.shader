shader_type canvas_item;

uniform sampler2D outline_texture;
uniform vec4 outline_color: hint_color;
uniform float selectSpeed = 10f;
uniform bool isSelected = false;
uniform bool isSlimed = false;
uniform sampler2D slimed_texture;
uniform bool isShade = false;
uniform sampler2D shade_texture;
uniform bool isActivated = false;

float line (vec2 p1, vec2 p2, vec2 uv, float a, vec2 pixelSize)
{
    float r = 0.;
    float one_px = 1.5f * pixelSize.x; 
    float d = distance(p1, p2);
    float duv = distance(p1, uv);
    r = 1.-floor(1.-(a*one_px)+distance (mix(p1, p2, clamp(duv/d, 0., 1.)),  uv));
        
    return r;
}

void fragment(){
	vec4 c;
	vec4 tile;
	
	if(isShade && !isActivated){
		tile = texture(shade_texture, UV);
		if(tile.a == 0f){
			tile = vec4(.2, .2, .2, 1f);
		}
	}
	else{
		tile = texture(TEXTURE, UV);
	}
	
	if(isActivated){
		vec2 p1 = vec2(0f, mod(TIME, 1.5) + .5);
		vec2 p2 = vec2(mod(TIME, 1.5) + .5, 0f);
		float line = clamp(line(p1, p2, SCREEN_UV, 1f, SCREEN_PIXEL_SIZE) , 0f, 1f);
		c = tile + vec4(.5 * line, .5 * line ,.5 * line, 0f);
	}
	else if(isSelected){
		vec4 outline = texture(outline_texture, UV);
		if(outline.a > 0f){
			c = outline_color * (sin(TIME  * selectSpeed) + 1f)/2f;
			c += tile;
		}
		else{
			c = tile;
		}		
	}
	else if(isSlimed){
		vec4 slimed = texture(slimed_texture, UV);
		if(slimed.a > 0f){
			c = slimed;
		}
		else{
			c = tile;
		}		
	}
	else{
		c = tile;
	}
	COLOR = c;
}
