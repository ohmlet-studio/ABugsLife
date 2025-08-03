shader_type canvas_item;

// Paramètres principaux
uniform float sparkle_intensity : hint_range(0.0, 2.0) = 1.0;
uniform float sparkle_speed : hint_range(0.1, 5.0) = 1.0;
uniform float sparkle_scale : hint_range(0.1, 10.0) = 3.0;
uniform float threshold : hint_range(0.0, 1.0) = 0.5; // Seuil pour les scintillements

// Modulate intégré
uniform vec4 modulate_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Contrôles avancés
uniform float noise_octaves : hint_range(1.0, 4.0) = 2.0;
uniform float flicker_frequency : hint_range(0.1, 10.0) = 2.0;
uniform bool invert_mask = false; // Inverse l'effet (révèle au lieu de masquer)

// Fonction de bruit pseudo-aléatoire
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Bruit de Perlin simple
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Bruit fractal (multi-octaves)
float fractal_noise(vec2 st, float octaves) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    
    for (float i = 0.0; i < octaves; i++) {
        value += amplitude * noise(st * frequency);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    
    return value;
}

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    
    // Application du modulate dès le début
    original_color *= modulate_color;
    
    // Animation temporelle
    float time = TIME * sparkle_speed;
    
    // Coordonnées avec échelle
    vec2 scaled_uv = UV * sparkle_scale;
    
    // Génération du bruit animé multi-couches
    float noise1 = fractal_noise(scaled_uv + vec2(time * 0.7, time * 0.3), noise_octaves);
    float noise2 = fractal_noise(scaled_uv * 1.3 + vec2(-time * 0.5, time * 0.8), noise_octaves);
    float noise3 = fractal_noise(scaled_uv * 0.7 + vec2(time * 1.2, -time * 0.6), noise_octaves);
    
    // Combinaison des bruits
    float combined_noise = (noise1 + noise2 * 0.7 + noise3 * 0.5) / 2.2;
    
    // Effet de scintillement rapide
    float flicker = sin(time * flicker_frequency + combined_noise * 10.0) * 0.5 + 0.5;
    combined_noise = mix(combined_noise, combined_noise * flicker, 0.3);
    
    // Application du seuil pour créer des zones de scintillement
    float sparkle_mask = smoothstep(threshold - 0.1, threshold + 0.1, combined_noise);
    
    // Option pour inverser le masque
    if (invert_mask) {
        sparkle_mask = 1.0 - sparkle_mask;
    }
    
    // Application du masque pour supprimer/révéler les parties
    float visibility = 1.0 - (sparkle_mask * sparkle_intensity);
    
    // Suppression de la couleur selon le masque
    vec3 final_color = original_color.rgb * visibility;
    float final_alpha = original_color.a * visibility;
    COLOR = vec4(final_color, final_alpha);
}