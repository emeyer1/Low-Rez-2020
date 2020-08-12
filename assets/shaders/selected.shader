shader_type canvas_item;
uniform sampler2D outline_texture;
uniform vec4 color: hint_color;
uniform bool isSelected = false;


void fragment(){
	vec4 outline = texture(outline_texture, UV);

	vec4 tile = texture(TEXTURE, UV);
	vec4 c;
	if(outline.a > 0f){
		c = color;
		c += tile;
	}
	else{
		c = tile;
	}
	COLOR = c;
}
