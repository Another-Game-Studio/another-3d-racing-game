shader_type spatial;

render_mode blend_add, cull_disabled;

uniform sampler2D portal_texture;
uniform vec4 outer_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform float scale : hint_range(0.0, 1.0) = 0.5;
uniform float rotation_speed = 0.2;
uniform float time_offset = 0.0;

uniform float inner_transparency : hint_range(0.0, 0.1) = 0.05;
uniform float glow_margin : hint_range(0.0, 0.1) = 0.1;

uniform vec4 primary_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 secondary_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform float emission_strength : hint_range(0.0, 16.0) = 2.0;

void fragment() {
    vec2 centered_uv = UV - vec2(0.5);
    float dist = length(centered_uv);
    float base_angle = atan(centered_uv.y, centered_uv.x);

    float t = TIME + time_offset;

    float angle_cw = base_angle + t * rotation_speed;
    float angle_ccw = base_angle - t * rotation_speed;

    float norm_angle_cw = (angle_cw + 3.14159265) / (2.0 * 3.14159265);
    float norm_angle_ccw = (angle_ccw + 3.14159265) / (2.0 * 3.14159265);

    vec2 polar_uv_cw = vec2(norm_angle_cw, dist / scale);
    vec2 polar_uv_ccw = vec2(norm_angle_ccw, dist / scale);

    vec4 color_cw = texture(portal_texture, polar_uv_cw);
    vec4 color_ccw = texture(portal_texture, polar_uv_ccw);
    vec4 combined_color = mix(color_cw, color_ccw, 0.5);

    float grayscale = combined_color.r;
    vec4 colorized = mix(secondary_color, primary_color, grayscale);

    float outer_fade = smoothstep(0.0, scale, dist);
    vec3 final_rgb = mix(colorized.rgb, outer_color.rgb, outer_fade);

    float alpha_fade = smoothstep(inner_transparency, scale - glow_margin, dist);
    float edge_falloff = smoothstep(scale - glow_margin, scale, dist);
    float final_alpha = mix(0.0, 1.0, alpha_fade) * (1.0 - edge_falloff);

    ALBEDO = final_rgb;
    ALPHA = mix(colorized.a, outer_color.a, outer_fade) * final_alpha;

    EMISSION = primary_color.rgb * grayscale * emission_strength;
}
