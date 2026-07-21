shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 0.2;

uniform float pattern_size : hint_range(50.0, 5000.0) = 600.0;

uniform vec3 color_dark : source_color = vec3(0.2, 0.0, 0.0);
uniform vec3 color_mid_low : source_color = vec3(0.5, 0.1, 0.0);
uniform vec3 color_mid_high : source_color = vec3(1.0, 0.5, 0.0);
uniform vec3 color_bright : source_color = vec3(1.0, 1.0, 0.0);
uniform vec3 glow_color : source_color = vec3(1.0, 0.3, 0.0);

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

    vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;

    i = mod(i, 289.0);
    vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
           + i.x + vec3(0.0, i1.x, 1.0));

    vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
    m = m * m;
    m = m * m;

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

float fbm(vec2 p) {
    float value = 0.0;
    float scale = 0.5;
    for (int i = 0; i < 4; i++) {
        float n = abs(simplex_noise(p)); 
        value += (1.0 - n) * scale; 
        p *= 2.0;
        scale *= 0.5;
    }
    return value;
}

void fragment() {
    vec2 pos = world_pos / pattern_size;
    float n = fbm(pos + vec2(TIME * speed * 0.2));
	
	float t1 = smoothstep(0.35, 0.40, n);
	float t2 = smoothstep(0.55, 0.60, n);
	float t3 = smoothstep(0.75, 0.80, n);

    vec3 color = mix(color_dark, color_mid_low, t1);
    color = mix(color, color_mid_high, t2);
    color = mix(color, color_bright, t3);

    float glow = smoothstep(0.6, 0.95, n);
    color += glow * glow_color * 0.7;

    COLOR = vec4(color, 1.0);
}