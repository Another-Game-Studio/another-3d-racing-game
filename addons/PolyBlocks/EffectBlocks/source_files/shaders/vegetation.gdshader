// PolyBlocks vegetation shader

shader_type spatial;
render_mode world_vertex_coords;

// Wind parameters
uniform float windSpeed : hint_range(0.1, 2.0) = 0.2;
uniform float windStrength : hint_range(0.0, 1.0) = 0.1;
uniform sampler2D windNoise;

// Material parameters
uniform sampler2D albedo : repeat_disable, source_color;

// Night time tint parameters
uniform vec3 nightColor : source_color = vec3(0.1, 0.2, 0.4); 
uniform float nightTime : hint_range(0.0, 1.0) = 0.0; 

void vertex() {
    vec2 world_uv_x = vec2(VERTEX.x / 20.0 + 0.5 * TIME * windSpeed, 0.5);
    vec2 world_uv_z = vec2(VERTEX.z / 20.0 + 0.5 * TIME * windSpeed, 0.5); 
    
    float wind_x = texture(windNoise, world_uv_x).x - 0.5;
    float wind_z = texture(windNoise, world_uv_z).z - 0.5;
    
    VERTEX.x += wind_x * windStrength * (1.0 - UV.y);
    VERTEX.z += wind_z * windStrength * (1.0 - UV.x);
}

void fragment() {
    vec4 loadAlbedo = texture(albedo, UV);
    
    // Apply night tint - lerp between original color and night color based on nightAmount
    vec3 finalColor = mix(loadAlbedo.rgb, loadAlbedo.rgb * nightColor, nightTime);
    
    ALBEDO = finalColor;
    ALPHA = loadAlbedo.a;
    ALPHA_SCISSOR_THRESHOLD = 0.5;
}