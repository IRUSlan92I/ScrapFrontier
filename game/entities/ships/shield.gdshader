shader_type canvas_item;

uniform float speed = 5.0;
uniform float scale = 20.0;
uniform float intensity = 1;

float rand(vec2 coord) {
    return fract(sin(dot(coord, vec2(12.9898, 78.233))) * 43758.5453);
}

float cellular(vec2 coord) {
    vec2 i = floor(coord);
    vec2 f = fract(coord);
    
    float min_dist = 1.0;
    
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = vec2(rand(i + neighbor), rand(i + neighbor + vec2(1000.0)));
            point = 0.5 * sin(TIME * speed + 6.2831 * point);
            vec2 diff = neighbor + point - f;
            float dist = length(diff);
            min_dist = min(min_dist, dist);
        }
    }
    
    return min_dist;
}

void fragment() {
    vec2 coord = UV * scale;
    
    float pattern = cellular(coord);
    
    float alpha = COLOR.a;
    if (pattern > intensity) {
        alpha = 0.0;
    }
    
    COLOR = vec4(COLOR.rgb, alpha);
}