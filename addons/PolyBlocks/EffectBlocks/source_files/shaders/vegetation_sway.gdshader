// polyBlocks vegetation_sway shader

shader_type spatial;

// Wind parameters
uniform float windSpeed : hint_range(0.5, 5.0) = 1.0;
uniform sampler2D albedo : repeat_disable, source_color;

// Night time tint parameters
uniform vec3 nightColor : source_color = vec3(0.1, 0.2, 0.4); 
uniform float nightTime : hint_range(0.0, 1.0) = 0.0; 

void vertex(){
	float Y = 1.0 - VERTEX.y;
	VERTEX.x += sin(NODE_POSITION_WORLD.x + TIME * windSpeed + Y) * (1.0 - Y) * 0.1;
}

void fragment() {
	vec4 loadAlbedo = texture(albedo, UV);

    // Apply night tint - lerp between original color and night color based on nightAmount
    vec3 finalColor = mix(loadAlbedo.rgb, loadAlbedo.rgb * nightColor, nightTime);

	ALBEDO = finalColor;
	ALPHA = loadAlbedo.a;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
