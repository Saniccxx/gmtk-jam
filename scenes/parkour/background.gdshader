shader_type canvas_item;

#define OCTAVES 6

highp float hash21(highp vec2 p) {
    highp vec3 p3 = fract(p.xyx * vec3(0.1031, 0.1030, 0.0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

highp float valueNoise(highp vec2 p) {
    highp vec2 i = floor(p);
    highp vec2 f = fract(p);
    highp float a = hash21(i);
    highp float b = hash21(i + vec2(1.0, 0.0));
    highp float c = hash21(i + vec2(0.0, 1.0));
    highp float d = hash21(i + vec2(1.0, 1.0));
    highp vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

highp float fbm(highp vec2 p, highp float t, float octaveOffset) {
    highp float value = 0.0;
    highp float amplitude = 0.5;
    mat2 rot = mat2(vec2(0.80, 0.60), vec2(-0.60, 0.80));
    for (int i = 0; i < OCTAVES; i++) {
        highp float rate = 0.15 + 0.05 * float(i);
        highp float phase = (float(i) + octaveOffset) * 2.4;
        highp vec2 orbit = vec2(cos(t * rate + phase), sin(t * rate + phase)) * 0.6;
        value += amplitude * valueNoise(p + orbit);
        p = rot * p * 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void fragment() {
    highp vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
    highp vec2 uv = (FRAGCOORD.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);

    highp float t = TIME * 0.5;

    highp vec2 warp1 = vec2(
        fbm(uv, t, 0.0),
        fbm(uv + vec2(5.2, 1.3), t, 1.0)
    );

    highp vec2 warp2 = vec2(
        fbm(uv + warp1 * 1.2 + vec2(1.7, 9.2), t, 2.0),
        fbm(uv + warp1 * 1.2 + vec2(8.3, 2.8), t, 3.0)
    );

    highp float f = fbm(uv + warp2, t, 0.0);

    vec3 deepColor = vec3(0.0, 0.0, 0.0);
    vec3 midColor = vec3(0.25, 0.65, 0.25);
    vec3 lightColor = vec3(0.95, 0.95, 0.55);

    vec3 color = mix(deepColor, midColor, smoothstep(0.1, 0.6, f));
    color = mix(color, lightColor, smoothstep(0.55, 0.95, f));

    color *= (0.6 + 0.4 * f);

    highp float dither = (hash21(FRAGCOORD.xy + vec2(t, 0.0)) - 0.5) / 255.0;
    color += dither;

    COLOR = vec4(color, 1.0);
}
