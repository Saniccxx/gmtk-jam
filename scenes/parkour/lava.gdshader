shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 0.2;
uniform float pattern_size : hint_range(50.0, 5000.0) = 1200.0;

uniform int detail_octaves : hint_range(1, 4) = 1;  
uniform float shadow_coverage : hint_range(0.0, 1.0) = 0.5;  
uniform float outline_thickness : hint_range(0.0, 0.1) = 0.03;

uniform vec4 ink_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 paper_color : source_color = vec4(1.0, 0.4, 0.4, 1.0);

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec3 permute(vec3 x) { 
	return mod(((x * 34.0) + 1.0) * x, 289.0); 
}

float simplex_noise(vec2 v) {
	const vec4 C = vec4(0.211324865405187, 0.366025403784439,
	                    -0.577350269189626, 0.024390243902439);
	vec2 i  = floor(v + dot(v, C.yy));
	vec2 x0 = v - i + dot(i, C.xx);

	vec2 i1 = step(x0.yx, x0.xy);
	vec4 x12 = x0.xyxy + C.xxzz;
	x12.xy -= i1;

	i = mod(i, 289.0);
	vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
	       + i.x + vec3(0.0, i1.x, 1.0));

	vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
	m *= m;
	m *= m;

	vec3 x = 2.0 * fract(p * C.www) - 1.0;
	vec3 h = abs(x) - 0.5;
	vec3 ox = floor(x + 0.5);
	vec3 a0 = x - ox;

	m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);

	vec3 g;
	g.x  = a0.x  * x0.x  + h.x  * x0.y;
	g.yz = a0.yz * x12.xz + h.yz * x12.yw;

	return 130.0 * dot(m, g);
}

float get_noise(vec2 p, int octaves) {
	float value = 0.0;
	float scale = 0.5;
	for (int i = 0; i < octaves; i++) {
		float n = abs(simplex_noise(p)); 
		value += (1.0 - n) * scale; 
		p *= 2.0;
		scale *= 0.5;
	}
	return value;
}

void fragment() {
	vec2 pos = (world_pos / pattern_size) + vec2(TIME * speed * 0.2);
	float n = get_noise(pos, detail_octaves);

	float threshold = 1.0 - shadow_coverage;

	float fill = step(threshold, n);

	float outline = step(abs(n - threshold), outline_thickness);

	float black_ink = clamp(fill + outline, 0.0, 1.0);

	COLOR = mix(paper_color, ink_color, black_ink);
}