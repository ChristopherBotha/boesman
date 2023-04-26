shader_type spatial;

uniform sampler2D heightmap;
uniform float height_ratio = 1.0;
uniform sampler2D _a;

void fragment() {
	ALBEDO = texture(_a,UV * 10.0).rgb;
}


void vertex(){
	VERTEX.y += texture(heightmap, UV).r * height_ratio;
}
