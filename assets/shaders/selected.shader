shader_type canvas_item;

void fragment(){
	COLOR.rgb = vec3(POINT_COORD.x  * SCREEN_PIXEL_SIZE.x);
}