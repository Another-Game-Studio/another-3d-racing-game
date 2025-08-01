// PolyBlocks water shader

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;
uniform sampler2D noise_texture;
uniform sampler2D depth_texture : hint_depth_texture;
uniform vec4 water_color : source_color = vec4(0.1, 0.4, 0.4, 1.0);
uniform vec4 ripple_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float wave_strength = 0.2;
uniform float wave_speed = 0.05;
uniform float water_transparency = 0.8;
uniform float water_roughness = 1.0;
uniform float water_depth_fade = 0.5;
uniform float edge_size = 2.0;
uniform float edge_intensity = 2.0;
uniform float ripple_intensity = 0.6;

vec3 get_noise(vec2 uv, float time) {
    vec4 noise1 = texture(noise_texture, uv + time * wave_speed);
    vec4 noise2 = texture(noise_texture, (uv - time * wave_speed) * 4.0);
    return noise1.rgb * noise2.rgb;
}

void vertex() {
    vec3 noise = get_noise(UV, TIME);
    VERTEX += NORMAL * wave_strength * noise;
}

void fragment() {
    vec3 noise = get_noise(UV, TIME);
    float enhanced_noise = pow(noise.x, 1.25);
    
    float depth_sample = texture(depth_texture, SCREEN_UV).r;
    vec4 depth_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, depth_sample, 1.0);
    depth_pos.xyz /= depth_pos.w;
    float depth_fade = clamp(1.0 - smoothstep(depth_pos.z + water_depth_fade, depth_pos.z, VERTEX.z), 0.0, 1.0);
    float water_depth = 1.0 - depth_fade;
    
    float edge = pow(water_depth, 24.0 / edge_size); 
    
    vec3 ripple_effect = mix(water_color.rgb, ripple_color.rgb, enhanced_noise * ripple_intensity);
    
    ALBEDO = mix(ripple_effect, ripple_color.rgb, edge * edge_intensity);
    ALPHA = water_transparency;
    ROUGHNESS = water_roughness;
}