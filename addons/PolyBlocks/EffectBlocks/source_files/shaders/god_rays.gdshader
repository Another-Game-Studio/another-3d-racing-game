shader_type spatial;
render_mode cull_disabled;

uniform float speed : hint_range(0.5, 10.0);
uniform sampler2D windNoise;
uniform vec3 tint_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float alpha_factor : hint_range(0.0, 1.0);
uniform sampler2D hGradient : repeat_disable;
uniform sampler2D vGradient : repeat_disable;

void fragment() {
    vec2 movingNoiseUV = vec2(UV.x, UV.y * 0.0 + (TIME * speed * 0.01));
    
    vec4 noiseValue = texture(windNoise, movingNoiseUV);
    vec4 loadGradient = texture(hGradient, vec2(UV.y, UV.x));
	vec4 finalGradient = loadGradient * texture(vGradient, UV);
	
    float noiseAlpha = noiseValue.r * finalGradient.r * alpha_factor;
    
    vec4 finalColor = vec4(finalGradient.rgb * tint_color, noiseAlpha);
    
    ALBEDO = finalColor.rgb;
    ALPHA = finalColor.a;
	EMISSION = finalColor.rgb*0.1;
}
