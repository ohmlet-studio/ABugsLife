shader_type canvas_item;

// Version utilisant BackBufferCopy pour capturer tous les layers
uniform float saturation : hint_range(0.0, 3.0) = 0.0;
uniform float brightness : hint_range(0.0, 2.0) = 1.0;
uniform float contrast : hint_range(0.0, 2.0) = 1.0;

// Utilise une BackBufferCopy node au lieu de SCREEN_TEXTURE
uniform sampler2D back_buffer : hint_default_black;

void fragment() {
    // Récupère la couleur depuis la BackBufferCopy
    vec4 original_color = texture(back_buffer, SCREEN_UV);
    
    // Calcul de la luminance
    vec3 luminance_weights = vec3(0.299, 0.587, 0.114);
    float luminance = dot(original_color.rgb, luminance_weights);
    
    // Mix entre grayscale et couleur originale
    vec3 saturated_color = mix(vec3(luminance), original_color.rgb, saturation);
    
    // Brightness et contrast
    saturated_color = saturated_color * brightness;
    saturated_color = ((saturated_color - 0.5) * contrast) + 0.5;
    
    COLOR = vec4(clamp(saturated_color, 0.0, 1.0), original_color.a);
}