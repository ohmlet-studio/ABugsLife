shader_type canvas_item;

// Version rapide avec box blur
uniform float blur_amount : hint_range(0.0, 20.0) = 2.0;
uniform int samples : hint_range(3, 32) = 9; // Nombre d'échantillons (impair recommandé)

// Options
uniform bool preserve_alpha = true;
uniform vec4 modulate_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec2 texture_size = 1.0 / TEXTURE_PIXEL_SIZE;
    vec2 blur_size = blur_amount / texture_size;
    
    vec4 color = vec4(0.0);
    float total_samples = 0.0;
    
    int half_samples = samples / 2;
    
    // Box blur (plus rapide que Gaussien)
    for (int x = -half_samples; x <= half_samples; x++) {
        for (int y = -half_samples; y <= half_samples; y++) {
            vec2 offset = vec2(float(x), float(y)) * blur_size;
            vec2 sample_uv = UV + offset;
            
            // Évite de sortir des limites
            if (sample_uv.x >= 0.0 && sample_uv.x <= 1.0 && 
                sample_uv.y >= 0.0 && sample_uv.y <= 1.0) {
                color += texture(TEXTURE, sample_uv);
                total_samples += 1.0;
            }
        }
    }
    
    color /= total_samples;
    
    // Préserve l'alpha original si demandé
    if (preserve_alpha) {
        vec4 original = texture(TEXTURE, UV);
        color.a = original.a;
    }
    
    COLOR = color * modulate_color;
}