// Modified from https://godotshaders.com/shader/procedural-hex-barrier-shader-for-godot-4/
shader_type spatial;
render_mode unshaded, depth_draw_never, world_vertex_coords;

uniform float density : hint_range(1.0, 100.0) = 50.0;
uniform float line_width : hint_range(0.001, 0.2) = 0.02;
uniform vec4 hex_line_color : source_color = vec4(0.2, 1.0, 1.0, 1.0);
uniform vec4 hex_color : source_color = vec4(0.01, 0.18, 0.7, 0.05);

uniform vec4 rim_color : source_color = vec4(0.5, 1.0, 1.0, 1.0);
uniform float rim_power : hint_range(0.1, 10.0) = 5.0;
uniform float rim_intensity : hint_range(0.0, 2.0) = 1.0;

uniform sampler2D noise_texture : source_color;
uniform float noise_strength : hint_range(0.0, 0.1) = 0.01;
uniform float noise_speed : hint_range(0.1, 5.0) = 1.0;

varying vec3 world_normal;
varying vec3 world_position;

float hex_cells(vec2 uv, float width, float height) {
    float x = uv.x * width * density;
    float y = mod(floor(x), 2.0) * 0.5 + (uv.y * height) * density;
    vec2 base_chip = abs(vec2(0.5) - mod(vec2(x, y), 1.0));
    return abs(max(base_chip.x * 1.5 + base_chip.y, base_chip.y * 2.0) - 1.0);
}

void vertex() {
    world_normal = NORMAL;
    world_position = VERTEX;
}

void fragment() {
    float height = 1.0;
    float width = 2.0;
    
    vec2 noise_uv = UV * 5.0 + TIME * noise_speed * 0.1;
    vec2 noise_offset = (texture(noise_texture, noise_uv).rg - 0.5) * 2.0 * noise_strength;
    
    vec2 wiggled_uv = UV + noise_offset;
    
    float hex = hex_cells(wiggled_uv, width, height);
    vec3 line_col = clamp(hex_line_color.rgb + 0.2, vec3(0.0), vec3(1.0));
    vec4 final_color = mix(
        hex_color,
        vec4(line_col, hex_line_color.a),
        float(hex < line_width)
    );
    
    vec3 view_dir = normalize(CAMERA_POSITION_WORLD - world_position);
    vec3 normal = normalize(world_normal);
    float rim_factor = 1.0 - max(dot(view_dir, normal), 0.0);
    rim_factor = pow(rim_factor, rim_power) * rim_intensity;
    
    final_color.rgb += rim_color.rgb * rim_factor;
    final_color.a = max(final_color.a, rim_factor * rim_color.a);
    
    ALBEDO = final_color.rgb;
    ALPHA = final_color.a;
}