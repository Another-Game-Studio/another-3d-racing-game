shader_type spatial;
render_mode unshaded, blend_mix;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float distortion_intensity : hint_range(0.0, 1.0) = 0.1;
uniform float noise_influence : hint_range(0.0, 1.0) = 1.0;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 center_uv = uv - vec2(0.5);

    float dist = length(center_uv);
    vec2 distortion_dir = normalize(center_uv);

    float noise = 1.0 + (random(uv) * 2.0 - 1.0) * noise_influence;

    // Apply a constant distortion based on distance from center
    vec2 offset = distortion_dir * distortion_intensity * dist * noise;

    vec4 distorted_color = texture(screen_texture, uv + offset);
    ALBEDO = distorted_color.rgb;
    ALPHA = distorted_color.a;
}
