// source: https://godotshaders.com/shader/magical-mist/

// Enable Volumetric Fog in WorldEnvironment
// Create a FogVolume and use this shader in its material
// For better results, place an omnilight on the base/center of the fogvolumen
// and in Project > Project Settings > Rendering > Environment increase 
// Volume Size and Volume Depth to around 196 (be sure to enable Advanced
// Settings to be able to modify this setting)

shader_type fog;

uniform sampler2D noise_tex : repeat_enable; // use a noise texture
uniform float noise_scale = 1.0;
uniform sampler2D grad_tex; // use a gradient or curve texture
uniform float grad_scale = 1.0;

uniform float density_scale = 1.0;

uniform float rotation_speed = 0.25;
uniform float rotate_with_height = 1.0;
uniform vec2 rotation_pivot = vec2(0.5);

uniform vec3 albedo_color_a : source_color = vec3(0.0, 0.0, 1.0);
uniform vec3 albedo_color_b : source_color = vec3(0.0, 1.0, 0.0);
uniform vec3 emission_color : source_color = vec3(1.0, 0.0, 0.0);

// this function was taken from godotshaders.com :)
vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));
	
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

void fog() {
	// sample noise texture
	vec2 noise_uv = UVW.xz;
	float rot_with_time = TIME;
	float rot_with_height = UVW.y * TAU * rotate_with_height;
	float rot_final = rot_with_time + rot_with_height;
	noise_uv = rotate(noise_uv, rotation_pivot, rot_final * rotation_speed);
	float noi1 = texture(noise_tex, noise_uv * noise_scale).r;	

	// compute distance to the rotation center	
	float dist = length(noise_uv - rotation_pivot);

	// sample grad texture
	vec2 grad_uv = vec2((1.0 - UVW.y) * grad_scale, 0.5);
	float grad = texture(grad_tex, grad_uv).r;
	
	// compute final density
	float dens = clamp( (noi1 * grad) - dist, 0.0, 1.0 );
	dens *= density_scale;
	
	// set output values
	ALBEDO = mix(albedo_color_a, albedo_color_b, dens);
	EMISSION = emission_color;
	DENSITY = dens;	
}