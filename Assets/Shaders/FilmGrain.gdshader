shader_type canvas_item;

// Uniforms
uniform sampler2D screen_texture : hint_screen_texture;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grain
uniform float grain_size : hint_range(0.1, 10.0) = 1.5; // Adjust the size of the grain
uniform float speed : hint_range(0.0, 10.0) = .000009; // Animation speed

void fragment() {
    // Sample the original screen texture
    vec4 original_color = texture(screen_texture, SCREEN_UV);

    // Animate the noise using TIME
    vec2 animated_uv = UV + TIME * speed * 0.1;
    
    // Generate animated random noise
    float noise = (fract(sin(dot(animated_uv, vec2(12.9898, 78.233))) * 43758.5453 + TIME * speed) - 0.5) * 2.0;

    // Add noise to the original color
    original_color.rgb += noise * grain_amount * grain_size;

    // Clamp the final color to make sure it stays in the valid range
    COLOR = clamp(original_color, 0.0, 1.0);
}