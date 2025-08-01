shader_type spatial;
render_mode blend_add, cull_disabled;

uniform sampler2D noise : repeat_enable;
uniform float time_scale = 4.0;
uniform float scale = 0.5;
uniform vec3 emission_color : source_color = vec3(0.2, 0.6, 1.0);
uniform float emission_strength : hint_range(1.0, 4.0) = 2.0;

void fragment() {
    vec2 space = (UV - vec2(0.5)) * 2.0 * scale;
    float time = TIME * time_scale;
    vec3 old_colo = ALBEDO;
    vec3 result = vec3(0.0);
    
    for(int i = 1; i <= 5; i++) {
        float intensive = 0.1 + 0.07 * float(i);
        vec2 pos = space;
        
        vec2 offset = (texture(noise, vec2(time * 0.35 * (0.5 + fract(sin(float(i) * 55.0))), space.y)).rg - vec2(0.5)) * intensive;
        
        vec2 modified_pos = pos + offset;
        float dist = abs(modified_pos.x);
        float rand_speed = 0.2 + 0.05 * fract(cos(float(i) * 1144.0));
        float gone = smoothstep(0.1 + 0.05 * (float(i) - 0.5), 1.0, texture(noise, pos + vec2(time * rand_speed)).r);
        
        result += gone * old_colo / dist * 0.01 * texture(noise, modified_pos + vec2(time)).r;
    }
    
    result *= emission_color;
    
    ALBEDO = result;
    EMISSION = result * emission_strength;
    ALPHA = length(result) * 0.33;
}
