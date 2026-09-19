shader_type spatial;

uniform float size : hint_range(1.0, 100.0) = 25.0;
uniform vec3 color1 : source_color = vec3(1.0, 1.0, 1.0); 
uniform vec3 color2 : source_color = vec3(0.1, 0.1, 0.1);

void fragment() {
    vec2 pos = floor(FRAGCOORD.xy / size);
    float pattern_mask = mod(pos.x + mod(pos.y, 2.0), 2.0);
    ALBEDO = mix(color1, color2, pattern_mask);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
