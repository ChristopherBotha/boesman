//shader_type spatial;
//render_mode cull_disabled;
//
//uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//uniform float speed: hint_range(-1, 1) = 0.0;
//
//uniform sampler2D noise1;
//uniform sampler2D noise2;
//uniform sampler2D normalmap: hint_normal;
//
//uniform vec4 color : source_color;
//uniform vec4 deep_water: source_color;
//
////depth-fade var
//uniform float beer_law_factor = 2.0;
//uniform float _distance = 0.0;
//
////foam var
//uniform vec4 edge_color: source_color;
//uniform float edge_scale = 0.25;
//uniform float near = 0.1;
//uniform float far = 100.0;
//
//// wave var
//uniform vec2 wave_strength = vec2(0.5, 0.25);
//uniform vec2 wave_frequ = vec2(12.0, 12.0);
//uniform vec2 time_factor = vec2(1.0, 2.0);
//
//float waves(vec2 pos, float time) {
//	return (wave_strength.y * sin(pos.y * wave_frequ.y + time * time_factor.y)) + (wave_strength.x * sin(pos.x * wave_frequ.x + time * time_factor.x));
//}
//
//void vertex() {
//	VERTEX.y += waves(VERTEX.xy, TIME);
//}
//
//float rim(float depth) {
//	depth = 2.0 * depth - 1.0;
//	return near * far / (far + depth * (near - far));
//}
//
//float calc_depth_fade(float depth, mat4 projection_matrix, 
//						vec4 fragcoord, float beer_factor, float __distance, vec3 vertex) {
//
//	float scene_depth = depth;
//
//	scene_depth = scene_depth * 2.0 - 1.0;
//	scene_depth = projection_matrix[3][2] / (scene_depth + projection_matrix[2][2]);
//	scene_depth = scene_depth + vertex.z; // z is negative
//
//	// application of beers law
//	scene_depth = exp(-scene_depth * beer_factor);
//
//	float screen_depth = fragcoord.z;
//
//	float depth_fade = (scene_depth - screen_depth) / __distance;
//
//	depth_fade = clamp(depth_fade, 0.0, 1.0);
//
//	return depth_fade;
//}
//
//void fragment() {
//	float time = TIME * speed;
//
//	vec3 n1 = texture(noise1, UV + time).rgb;
//	vec3 n2 = texture(noise2, UV - time * 0.2).rgb;
//
//	vec2 uv_movement = UV * 4.0;
//	uv_movement += TIME * speed * 4.0;
//
//	float sum = (n1.r + n2.r) - 1.0;
//
//	float z_depth = rim(texture(DEPTH_TEXTURE, SCREEN_UV).x);
//	float z_pos = rim(FRAGCOORD.z);
//	float diff = z_depth - z_pos;
//
//	// depth-fade
//	float z_depth_fade = calc_depth_fade(texture(DEPTH_TEXTURE, SCREEN_UV).x, PROJECTION_MATRIX, FRAGCOORD, beer_law_factor, _distance, VERTEX);
//	float z_fade = rim(FRAGCOORD.z);
//	float fade_diff = z_depth_fade - z_fade;
//
//	vec4 gradientcolor = mix(color, deep_water, z_depth_fade);
//
//	vec2 displacement = vec2(sum * 0.1);
//	diff += displacement.x * 70.0;
//
//	vec4 col = mix(edge_color, gradientcolor, step(edge_scale, diff));
//
//	vec4 alpha = texture(SCREEN_TEXTURE, SCREEN_UV + displacement);
//
//
//	float fin = 0.0;
//	if (sum > 0.0 && sum < 0.4) fin = 0.1;
//	if (sum > 0.4 && sum < 0.8) fin = 0.0;
//	if (sum > 0.8) fin = 1.0;
//
//	// konvertier fin in vec3 um
//	ALBEDO = vec3(fin) + mix(alpha.rgb, col.rgb, gradientcolor.a);
//
//	NORMAL_MAP = texture(normalmap, uv_movement).rgb;
//
//	ROUGHNESS = 0.1;
//}

//shader_type spatial;
//
//uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//// Water color
//uniform vec4 out_color: source_color = vec4(0.0, 0.2, 1.0, 1.0);
//// Amount of height for each triangle
//uniform float amount: hint_range(0.2, 5.0, 0.1) = 0.8;
//// The speed of the trangles height change
//uniform float speed: hint_range(0.1, 5.0, 0.1) = 1;
//// Beer factor (used to calculate how transparent the water is going to be) if equals to 0.0 then the alpha is going to be the out_color's alpha
//uniform float beer_factor = 0.2;
//uniform float metallic = 0.6;
//uniform float specular = 0.5;
//uniform float roughness = 0.2;
//
//float generateOffset(float x, float z, float val1, float val2, float time) {
//	float radiansX = ((mod(x + z * x * val1, amount) / amount) + (time * speed) * mod(x * 0.8 + z, 1.5)) * 2.0 * 3.14;
//	float radiansZ = ((mod(val2 * (z * x + x * z), amount) / amount) + (time * speed) * 2.0 * mod(x, 2.0)) * 2.0 * 3.14;
//
//	return amount * 0.5 * (sin(radiansZ) * cos(radiansX));
//}
//
//vec3 applyDistortion(vec3 vertex, float time) {
//	float xd = generateOffset(vertex.x, vertex.z, 0.2, 0.1, time);
//	float yd = generateOffset(vertex.x, vertex.z, 0.1, 0.3, time);
//	float zd = generateOffset(vertex.x, vertex.z, 0.15, 0.2, time);
//
//	return vertex + vec3(xd, yd, zd);
//}
//
//void vertex() {
//	VERTEX = applyDistortion(VERTEX, TIME * 0.1);
//}
//
//void fragment() {
//	NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));
//	METALLIC = metallic;
//	SPECULAR = specular;
//	ROUGHNESS = roughness;
//	ALBEDO = out_color.rgb;
//
//	if (beer_factor != 0.0) {
//		float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
//
//		depth = depth * 2.0 - 1.0;
//		depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
//		depth = depth + VERTEX.z;
//
//		depth = exp(-depth * beer_factor);
//		ALPHA = clamp(1.0 - depth, 0.0, 1.0);
//	} else {
//		ALPHA = out_color.a;
//	}
//}

/**
* Ported from the original unity shader by Erik Roystan Ross
* https://roystan.net/articles/toon-water.html
* https://github.com/IronWarrior/ToonWaterShader
* Camera Depth taken from Bastiaan Olij's video on: https://www.youtube.com/watch?v=Jq3he9Lbj7M
*/
//
shader_type spatial;

const float SMOOTHSTEP_AA = 0.01;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform sampler2D surfaceNoise;
uniform sampler2D distortNoise;

uniform float beer_factor = 0.8;

uniform float foam_distance = 0.01;
uniform float foam_max_distance = 0.4;
uniform float foam_min_distance = 0.04;
uniform vec4 foam_color: source_color  = vec4(1.0);

uniform vec2 surface_noise_tiling = vec2(1.0, 4.0);
uniform vec3 surface_noise_scroll = vec3(0.03, 0.03, 0.0);
uniform float surface_noise_cutoff: hint_range(0, 1) = 0.777;
uniform float surface_distortion_amount: hint_range(0, 1) = 0.27;

uniform vec4 _DepthGradientShallow: source_color = vec4(0.325, 0.807, 0.971, 0.725);
uniform vec4 _DepthGradientDeep: source_color = vec4(0.086, 0.407, 1, 0.749);
uniform float _DepthMaxDistance: hint_range(0, 1) = 1.0;
uniform float _DepthFactor = 1.0;

varying vec2 noiseUV;
varying vec2 distortUV;
varying vec3 viewNormal;

vec4 alphaBlend(vec4 top, vec4 bottom)
{
	vec3 color = (top.rgb * top.a) + (bottom.rgb * (1.0 - top.a));
	float alpha = top.a + bottom.a * (1.0 - top.a);

	return vec4(color, alpha);
}

void vertex() {
	viewNormal = (MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
	noiseUV = UV * surface_noise_tiling;
	distortUV = UV;
}

void fragment(){
	// https://www.youtube.com/watch?v=Jq3he9Lbj7M
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
	depth = depth * 2.0 - 1.0;
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
	depth = depth + VERTEX.z;
	depth = exp(-depth * beer_factor);
	depth = 1.0 - depth;

	// Still unsure how to get properly the NORMAL from the camera
	// this was my best attempt
	vec3 existingNormal = vec3(dFdx(depth), dFdy(depth), 0);

	float normalDot = clamp(dot(existingNormal.xyz, viewNormal), 0.0, 1.0);
	float foamDistance = mix(foam_max_distance, foam_min_distance, normalDot);

	float foamDepth = clamp(depth / foamDistance, 0.0, 1.0);
	float surfaceNoiseCutoff = foamDepth * surface_noise_cutoff;

	vec4 distortNoiseSample = texture(distortNoise, distortUV);
	vec2 distortAmount = (distortNoiseSample.xy * 2.0 -1.0) * surface_distortion_amount;

	vec2 noise_uv = vec2(
		(noiseUV.x + TIME * surface_noise_scroll.x) + distortAmount.x , 
		(noiseUV.y + TIME * surface_noise_scroll.y + distortAmount.y)
	);
	float surfaceNoiseSample = texture(surfaceNoise, noise_uv).r;
	float surfaceNoiseAmount = smoothstep(surfaceNoiseCutoff - SMOOTHSTEP_AA, surfaceNoiseCutoff + SMOOTHSTEP_AA, surfaceNoiseSample);

	float waterDepth = clamp(depth / _DepthMaxDistance, 0.0, 1.0) * _DepthFactor;
	vec4 waterColor = mix(_DepthGradientShallow, _DepthGradientDeep, waterDepth);

	vec4 surfaceNoiseColor = foam_color;
    surfaceNoiseColor.a *= surfaceNoiseAmount;
	vec4 color = alphaBlend(surfaceNoiseColor, waterColor);

	ALBEDO = color.rgb;
	ALPHA = color.a;
}

/*
Realistic Water Shader for Godot 3.4 
Modified to work with Godot 3.4 with thanks to jmarceno.
Copyright (c) 2019 UnionBytes, Achim Menzel (alias AiYori)
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- UnionBytes 
-- YouTube: www.youtube.com/user/UnionBytes
*/


// For this shader min. GODOT 3.1.1 is required, because 3.1 has a depth buffer bug!
//shader_type 	spatial;
//render_mode 	cull_back,diffuse_burley,specular_schlick_ggx, blend_mix;
//
//uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//// Wave settings:
//uniform float	wave_speed		 = 0.5; // Speed scale for the waves
//uniform vec4	wave_a			 = vec4(1.0, 1.0, 0.35, 3.0); 	// xy = Direction, z = Steepness, w = Length
//uniform	vec4	wave_b			 = vec4(1.0, 0.6, 0.30, 1.55);	// xy = Direction, z = Steepness, w = Length
//uniform	vec4	wave_c			 = vec4(1.0, 1.3, 0.25, 0.9); 	// xy = Direction, z = Steepness, w = Length
//
//// Surface settings:
//uniform vec2 	sampler_scale 	 = vec2(0.25, 0.25); 			// Scale for the sampler
//uniform vec2	sampler_direction= vec2(0.05, 0.04); 			// Direction and speed for the sampler offset
//
//uniform sampler2D uv_sampler : source_color; 						// UV motion sampler for shifting the normalmap
//uniform vec2 	uv_sampler_scale = vec2(0.25, 0.25); 			// UV sampler scale
//uniform float 	uv_sampler_strength = 0.04; 					// UV shifting strength
//
//uniform sampler2D normalmap_a_sampler : hint_normal;			// Normalmap sampler A
//uniform sampler2D normalmap_b_sampler : hint_normal;			// Normalmap sampler B
//
//uniform sampler2D foam_sampler : source_color;					// Foam sampler
//uniform float 	foam_level 		 = 0.5;							// Foam level -> distance from the object (0.0 - 0.5)
//
//// Volume settings:
//uniform float 	refraction 		 = 0.075;						// Refraction of the water
//
//uniform vec4 	color_deep : source_color;						// Color for deep places in the water, medium to dark blue
//uniform vec4 	color_shallow : source_color;						// Color for lower places in the water, bright blue - green
//uniform float 	beers_law		 = 2.0;							// Beers law value, regulates the blending size to the deep water level
//uniform float 	depth_offset	 = -0.75;						// Offset for the blending
//
//// Projector for the water caustics:
//uniform mat4	projector;										// Projector matrix, mostly the matric of the sun / directlight
//uniform sampler2DArray caustic_sampler ;			// Caustic sampler, (Texture array with 16 Textures for the animation)
//
//
//// Vertex -> Fragment:
//varying float 	vertex_height;									// Height of the water surface
//varying vec3 	vertex_normal;									// Vertex normal -> Needed for refraction calculation
//varying vec3 	vertex_binormal;								// Vertex binormal -> Needed for refraction calculation
//varying vec3 	vertex_tangent;									// Vertex tangent -> Needed for refraction calculation
//
//varying mat4 	inv_mvp; 										// Inverse ModelViewProjection matrix -> Needed for caustic projection
//
//
//// Wave function:
//vec4 wave(vec4 parameter, vec2 position, float time, inout vec3 tangent, inout vec3 binormal)
//{
//	float	wave_steepness	 = parameter.z;
//	float	wave_length		 = parameter.w;
//
//	float	k				 = 2.0 * 3.14159265359 / wave_length;
//	float 	c 				 = sqrt(9.8 / k);
//	vec2	d				 = normalize(parameter.xy);
//	float 	f 				 = k * (dot(d, position) - c * time);
//	float 	a				 = wave_steepness / k;
//
//			tangent			+= normalize(vec3(1.0-d.x * d.x * (wave_steepness * sin(f)), d.x * (wave_steepness * cos(f)), -d.x * d.y * (wave_steepness * sin(f))));
//			binormal		+= normalize(vec3(-d.x * d.y * (wave_steepness * sin(f)), d.y * (wave_steepness * cos(f)), 1.0-d.y * d.y * (wave_steepness * sin(f))));
//
//	return vec4(d.x * (a * cos(f)), a * sin(f) * 0.25, d.y * (a * cos(f)), 0.0);
//}
//
//
//// Vertex shader:
//void vertex()
//{
//	float	time			 = TIME * wave_speed;
//
//	vec4	vertex			 = vec4(VERTEX, 1.0);
//	vec3	vertex_position  = (MODEL_MATRIX * vertex).xyz;
//
//	vec3 tang = vec3(0.0, 0.0, 0.0);
//	vec3 bin = vec3(0.0, 0.0, 0.0);
//
//	vertex 			+= wave(wave_a, vertex_position.xz, time, tang, bin);
//	vertex 			+= wave(wave_b, vertex_position.xz, time, tang, bin);
//	vertex 			+= wave(wave_c, vertex_position.xz, time, tang, bin);
//
//	vertex_tangent 	 = tang;
//	vertex_binormal  = bin;
//
//	vertex_position  = vertex.xyz;
//
//	vertex_height	 = (PROJECTION_MATRIX * MODELVIEW_MATRIX * vertex).z;
//
//	TANGENT			 = vertex_tangent;
//	BINORMAL		 = vertex_binormal;
//	vertex_normal	 = normalize(cross(vertex_binormal, vertex_tangent));
//	NORMAL			 = vertex_normal;
//
//	UV				 = vertex.xz * sampler_scale;
//
//	VERTEX			 = vertex.xyz;
//
//	inv_mvp = inverse(PROJECTION_MATRIX * MODELVIEW_MATRIX);
//}
//
//
//// Fragment shader:
//void fragment()
//{
//	// Calculation of the UV with the UV motion sampler
//	vec2	uv_offset 					 = sampler_direction * TIME;
//	vec2 	uv_sampler_uv 				 = UV * uv_sampler_scale + uv_offset;
//	vec2	uv_sampler_uv_offset 		 = uv_sampler_strength * texture(uv_sampler, uv_sampler_uv).rg * 2.0 - 1.0;
//	vec2 	uv 							 = UV + uv_sampler_uv_offset;
//
//	// Normalmap:
//	vec3 	normalmap					 = texture(normalmap_a_sampler, uv - uv_offset*2.0).rgb * 0.75;		// 75 % sampler A
//			normalmap 					+= texture(normalmap_b_sampler, uv + uv_offset).rgb * 0.25;			// 25 % sampler B
//
//	// Refraction UV:
//	vec3	ref_normalmap				 = normalmap * 2.0 - 1.0;
//			ref_normalmap				 = normalize(vertex_tangent*ref_normalmap.x + vertex_binormal*ref_normalmap.y + vertex_normal*ref_normalmap.z);
//	vec2 	ref_uv						 = SCREEN_UV + (ref_normalmap.xy * refraction) / vertex_height;
//
//	// Ground depth:
//	float 	depth_raw					 = texture(DEPTH_TEXTURE, ref_uv).r * 2.0 - 1.0;
//	float	depth						 = PROJECTION_MATRIX[3][2] / (depth_raw + PROJECTION_MATRIX[2][2]);
//
//	float 	depth_blend 				 = exp((depth+VERTEX.z + depth_offset) * -beers_law);
//			depth_blend 				 = clamp(1.0-depth_blend, 0.0, 1.0);	
//	float	depth_blend_pow				 = clamp(pow(depth_blend, 2.5), 0.0, 1.0);
//
//	// Ground color:
//	vec3 	screen_color 				 = textureLod(SCREEN_TEXTURE, ref_uv, depth_blend_pow * 2.5).rgb;
//
//	vec3 	dye_color 					 = mix(color_shallow.rgb, color_deep.rgb, depth_blend_pow);
//	vec3	color 						 = mix(screen_color*dye_color, dye_color*0.25, depth_blend_pow*0.5);
//
//	// Caustic screen projection
//	vec4 	caustic_screenPos 			 = vec4(ref_uv*2.0-1.0, depth_raw, 1.0);
//	vec4 	caustic_localPos 			 = inv_mvp * caustic_screenPos;
//			caustic_localPos			 = vec4(caustic_localPos.xyz/caustic_localPos.w, caustic_localPos.w);
//
//	vec2 	caustic_Uv 					 = caustic_localPos.xz / vec2(1024.0) + 0.5;
//	vec4	caustic_color				 = texture(caustic_sampler, vec3(caustic_Uv*300.0, mod(TIME*14.0, 16.0)));
//
//			color 						*= 1.0 + pow(caustic_color.r, 1.50) * (1.0-depth_blend) * 6.0;
//
//	// Foam:
//			if(depth + VERTEX.z < vertex_height-0.1)
//			{
//				float foam_noise = clamp(pow(texture(foam_sampler, (uv*4.0) - uv_offset).r, 10.0)*40.0, 0.0, 0.2);
//				float foam_mix = clamp(pow((1.0-(depth + VERTEX.z) + foam_noise), 8.0) * foam_noise * 0.4, 0.0, 1.0);
//				color = mix(color, vec3(1.0), foam_mix);
//			}
//
//	// Set all values:
//	ALBEDO = color;
//	METALLIC = 0.1;
//	ROUGHNESS = 0.2;
//	SPECULAR = 0.2 + depth_blend_pow * 0.4;
//	NORMAL_MAP = normalmap;
//	NORMAL_MAP_DEPTH = 1.25;
//}