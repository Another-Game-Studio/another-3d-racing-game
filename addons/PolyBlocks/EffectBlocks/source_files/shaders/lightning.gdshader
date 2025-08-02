// PolyBlocks lightning shader

shader_type spatial;
render_mode blend_add, depth_draw_always, cull_disabled, unshaded, vertex_lighting;

uniform vec4 lightning_color : source_color = vec4(0.0, 0.5, 1.0, 1.0);
uniform vec4 glow_color : source_color = vec4(0.3, 0.5, 1.0, 0.6);
uniform float intensity : hint_range(0.0, 5.0) = 4.0;
uniform float noise_scale : hint_range(0.1, 10.0) = 4.0;
uniform float branch_scale : hint_range(0.1, 5.0) = 1.0;
uniform float thickness : hint_range(0.0, 1.0) = 0.2;
uniform float jitter : hint_range(0.0, 1.0) = 0.35;
uniform float speed : hint_range(0.1, 10.0) = 8.0;
uniform float glow_width : hint_range(0.0, 1.0) = 0.15;
uniform float flicker_speed : hint_range(0.0, 10.0) = 4.0;
uniform float flicker_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float vertex_displacement : hint_range(0.0, 1.0) = 0.2;
uniform bool use_vertex_color = true;
uniform float vertex_color_mix : hint_range(0.0, 1.0) = 0.8;

uniform bool y_billboard = true;
uniform float y_stretch : hint_range(0.1, 10.0) = 1.0;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 uv) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(uv * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

float lightning_shape(vec2 uv, float time) {
    float centerLine = abs(uv.x);
    vec2 noiseUV = vec2(uv.y * noise_scale + time * speed, uv.x * 5.0);
    float noiseVal = fbm(noiseUV) * jitter;
    centerLine += noiseVal * 0.5;
    
    vec2 branchUV = vec2(uv.y * branch_scale + time * speed * 1.2, uv.x * 7.0);
    float branches = fbm(branchUV) * 0.5;
    
    float shape = smoothstep(thickness, thickness * 0.5, centerLine);
    shape += smoothstep(thickness * 0.7, thickness * 0.3, centerLine + branches * 0.5) * 0.4;
    
    return clamp(shape, 0.0, 1.0);
}

void vertex() {
   
    float vertex_intensity = 1.0;
    if (use_vertex_color) {
        vertex_intensity = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
    }
    
    if (y_billboard) {
        
        vec3 camera_pos = INV_VIEW_MATRIX[3].xyz;
        
        
        vec3 particle_pos = MODEL_MATRIX[3].xyz; 
        vec3 to_camera = normalize(camera_pos - particle_pos);
        

        vec3 right = normalize(cross(vec3(0.0, 1.0, 0.0), to_camera));
        vec3 up = vec3(0.0, y_stretch, 0.0); 
        vec3 forward = normalize(cross(right, vec3(0.0, 1.0, 0.0)));
        
       
        vec3 local_pos = VERTEX;
        
        
        mat4 billboard_matrix = mat4(
            vec4(right, 0.0),
            vec4(up, 0.0),
            vec4(forward, 0.0),
            MODEL_MATRIX[3]
        );
        
 
        vec3 billboarded_pos = billboard_matrix[0].xyz * local_pos.x +
                              billboard_matrix[1].xyz * local_pos.y +
                              billboard_matrix[2].xyz * local_pos.z;
        
        
        VERTEX = billboarded_pos;
    }
    
    
    float noise_val = fbm(VERTEX.xy + TIME * 0.3) * 2.0 - 1.0;
    VERTEX += NORMAL * noise_val * vertex_displacement * vertex_intensity;
}

void fragment() {
    vec2 centered_uv = UV * 2.0 - 1.0;
    float time = TIME;
    
    float flicker = 1.0 + flicker_intensity * sin(time * flicker_speed * 6.28);
    
    float lightning = lightning_shape(centered_uv, time) * flicker;
    float glow = lightning_shape(centered_uv, time * 0.8) * glow_width;
    glow = smoothstep(0.0, glow_width, glow);
    
    float edge_fade = 1.0 - smoothstep(0.85, 1.0, abs(centered_uv.x));
    
    vec4 base_lightning = lightning_color * lightning * intensity;
    vec4 base_glow = glow_color * glow;
    vec4 base_final = base_lightning + base_glow;
    
    vec4 final_color = base_final;
    if (use_vertex_color) {
        final_color.rgb = mix(base_final.rgb, COLOR.rgb * lightning * intensity, vertex_color_mix);
        final_color.a = base_final.a * COLOR.a;
    }
    
    final_color.a *= edge_fade;
    
    ALBEDO = final_color.rgb;
    ALPHA = final_color.a;
    EMISSION = final_color.rgb * intensity;
}