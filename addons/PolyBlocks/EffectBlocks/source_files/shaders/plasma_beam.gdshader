shader_type spatial;

uniform float overall_speed = 1.0;
uniform float scale = 5.0;
uniform bool reverse_direction = true;

uniform vec4 line_color: source_color = vec4(0.2, 0.8, 0.4, 1.0);
uniform float line_min_width = 1.0;
uniform float line_max_width = 2.0;
uniform float line_speed = 2.0;
uniform float line_amplitude = 1.0;
uniform float line_frequency = 0.2;
uniform int lines_per_group = 8;

uniform float offset_frequency = 0.5;
uniform float offset_speed = 1.33;
uniform float min_offset_spread = 0.0;
uniform float max_offset_spread = 2.0;

uniform float emission_strength = 2.0;

#define drawCircle(P, r, U)     smoothstep(r + 0.015, r, length(U - (P)))
#define drawSmoothLine(P, w, t) smoothstep((w) / 2.0, 0.0, abs(P - (t)))
#define drawCrispLine(P, w, t)  smoothstep(0.015, 0.0, abs(P - (w) / 2.0 - (t)))

float random(float t) {
    return (cos(t) + cos(t * 1.3 + 1.3) + cos(t * 1.4 + 1.4)) / 3.0;
}

float getPlasmaX(float y, float verticalFade, float offset) {
    float time = reverse_direction ? -TIME : TIME;
    return random(y * line_frequency + time * line_speed * overall_speed) * verticalFade * line_amplitude + offset;
}

void fragment() {
    vec2 uv = UV;
    vec2 space = (UV - vec2(0.5)) * 2.0 * scale;
    
    float horizontalFade = 1.0 - (cos(uv.x * 6.28) * 0.5 + 0.5);
    float verticalFade = 1.0 - (cos(uv.y * 6.28) * 0.5 + 0.5);
    
    float time = reverse_direction ? -TIME : TIME;
    vec4 lines = vec4(0);
    
    for (int l = 0; l < lines_per_group; l++) {
        float normalizedLineIndex = float(l) / float(lines_per_group);
        float offsetTime = time * offset_speed * overall_speed;
        float offsetPosition = float(l) + space.y * offset_frequency;
        float rand = random(offsetPosition + offsetTime) * 0.5 + 0.5;
        float halfWidth = mix(line_min_width, line_max_width, rand * verticalFade) / 2.0;
        float offset = random(offsetPosition + offsetTime * (1.0 + normalizedLineIndex)) * mix(min_offset_spread, max_offset_spread, verticalFade);
        float linePosition = getPlasmaX(space.y, verticalFade, offset);
        float line = drawSmoothLine(linePosition, halfWidth, space.x) / 2.0 + drawCrispLine(linePosition, halfWidth * 0.15, space.x);
        
        float circleY = mod(float(l) + time * line_speed * overall_speed, 25.0) - 12.0;
        vec2 circlePosition = vec2(getPlasmaX(circleY, verticalFade, offset), circleY);
        float circle = drawCircle(circlePosition, 0.01, space) * 4.0;
        
        line = line + circle;
        lines += line * line_color * rand;
    }
    
    ALBEDO = lines.rgb;
    ALPHA = lines.a;
    EMISSION = lines.rgb * emission_strength;
}
