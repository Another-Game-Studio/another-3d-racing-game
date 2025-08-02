shader_type spatial;

render_mode blend_mix, depth_draw_always, cull_disabled, diffuse_toon, specular_toon;

uniform vec4 tint : source_color = vec4(0.4, 0.4, 0.6, 1.0);
uniform float tint_amount : hint_range(0, 1.0) = 0.50;
uniform sampler2D texture_albedo : source_color, filter_nearest;
uniform sampler2D gradient;
uniform sampler2D noise_texture : hint_default_black;
uniform float noise_strength : hint_range(0, 1.0) = 0.5;
uniform float ao_strength : hint_range(0, 4.0, 0.1) = 2.0;
uniform float ao_radius : hint_range(0, 1, 0.05) = 0.2;
uniform float noise_scale = 0.05;
uniform sampler2D emission_texture : source_color, filter_nearest;
uniform float emission_strength : hint_range(0.0, 16.0) = 1.0;
uniform float flicker_speed : hint_range(0.1, 10.0) = 1.0;

uniform vec3 fresnel_color : source_color = vec3(0.0, 0.7, 0.9);
uniform float fresnel_amount : hint_range(0.0, 16.0) = 10.0;
uniform float fresnel_intensity : hint_range(0.0, 10.0) = 0.5;


varying vec3 normal_vec;
varying vec3 world_pos;

vec3 fresnel_glow(float amount, float intensity, vec3 color, vec3 normal, vec3 view) {
    return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void vertex() {
    normal_vec = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    
    float ao = 1.0 - (1.0 - dot(normal_vec, vec3(0.0, 1.0, 0.0))) * ao_strength;
    COLOR.rgb = vec3(ao);
}


void fragment() {
    vec2 base_uv = UV;
    vec4 albedo_tex = texture(texture_albedo, base_uv);
    
    float ao = COLOR.r;
    ao = mix(1.0, ao, ao_radius);
    
    vec3 final_color = mix(albedo_tex.rgb, albedo_tex.rgb * tint.rgb, tint_amount);

    vec3 fresnel = fresnel_glow(fresnel_amount, fresnel_intensity, fresnel_color, NORMAL, VIEW);
    final_color += fresnel;

    ALBEDO = final_color * ao;
    ALPHA = albedo_tex.a;
    
    float position_offset = fract(world_pos.x * 0.001 + world_pos.y * 0.1 + world_pos.z * 1.0);
    float time_scale = (TIME + position_offset * 1.0) * flicker_speed * 0.05;
    float random_value = texture(noise_texture, vec2(time_scale)).r;
    float flicker = (random_value < 0.3) ? 0.0 : 1.0;
    
    vec4 emission_tex = texture(emission_texture, base_uv);
    EMISSION = emission_tex.rgb * emission_strength * flicker;
}

void light() {
    float dotproduct = clamp(dot(normal_vec, LIGHT), -1.0, 1.0);
    vec2 noise_uv = (world_pos.xz - world_pos.yz) * noise_scale;
    float noise = texture(noise_texture, noise_uv).r;
    
    float noisy_dot = dotproduct + (noise - 0.5) * noise_strength;
    float sample = clamp((noisy_dot) + ATTENUATION / 5.0, 0.05, 0.95);
    vec4 shaded = texture(gradient, vec2(sample, 0.0));
    
    DIFFUSE_LIGHT += clamp((shaded.rgb * LIGHT_COLOR), 0.0, 1.0);
}
