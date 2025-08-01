// PolyBlocks hologram shader

shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_disabled, unshaded;

uniform vec4 hologram_color : source_color = vec4(0.0, 0.8, 1.0, 0.3);
uniform float scan_line_speed : hint_range(0.0, 10.0) = 2.0;
uniform float scan_line_size : hint_range(1.0, 100.0) = 30.0;
uniform float flicker_strength : hint_range(0.0, 1.0) = 0.03;
uniform float rim_light_strength : hint_range(0.0, 10.0) = 2.0;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.25;
uniform sampler2D noise_texture : hint_default_black;

varying vec3 vertex_pos;
varying vec3 normal;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void vertex() {
    vertex_pos = VERTEX;
    normal = NORMAL;
}

void fragment() {
    float rim = 1.0 - dot(NORMAL, VIEW);
    rim = pow(rim, rim_light_strength);
    
    float scan_line = sin(vertex_pos.y * scan_line_size - TIME * scan_line_speed);
    scan_line = (scan_line + 1.0) * 0.5;
    
    vec2 noise_uv = UV * 2.0 + TIME * 0.1;
    float noise = texture(noise_texture, noise_uv).r;
    
    float flicker = random(vec2(TIME * 2.0, TIME * 3.0));
    flicker = mix(1.0, flicker, flicker_strength);
    
    vec4 final_color = hologram_color;
    final_color.a *= mix(0.5, 1.0, scan_line);
    final_color.a *= mix(1.0, noise, noise_strength);
    final_color.a *= flicker;
    final_color.rgb += rim * hologram_color.rgb;
    
    ALBEDO = final_color.rgb;
    ALPHA = final_color.a;
    EMISSION = final_color.rgb * 2.0;
}
