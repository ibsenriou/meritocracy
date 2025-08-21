shader_type canvas_item;

// Pega a imagem já renderizada atrás deste nó:
uniform sampler2D screen_texture : hint_screen_texture;

// Intensidade do blur e escurecimento
uniform float radius : hint_range(0.0, 8.0) = 3.5;
uniform float darken : hint_range(0.0, 0.5) = 0.12;

void fragment() {
    // UV da tela inteira (não o UV local do retângulo)
    vec2 uv = SCREEN_UV;

    // Tamanho de um pixel em coordenadas de tela
    vec2 texel = SCREEN_PIXEL_SIZE * radius;

    // Blur 9-amostras simples (rápido e bonito o suficiente pra modal)
    vec4 acc = texture(screen_texture, uv) * 0.24;

    acc += texture(screen_texture, uv + vec2( texel.x, 0.0)) * 0.12;
    acc += texture(screen_texture, uv + vec2(-texel.x, 0.0)) * 0.12;
    acc += texture(screen_texture, uv + vec2(0.0,  texel.y)) * 0.12;
    acc += texture(screen_texture, uv + vec2(0.0, -texel.y)) * 0.12;

    acc += texture(screen_texture, uv + vec2( texel.x,  texel.y)) * 0.08;
    acc += texture(screen_texture, uv + vec2(-texel.x,  texel.y)) * 0.08;
    acc += texture(screen_texture, uv + vec2( texel.x, -texel.y)) * 0.08;
    acc += texture(screen_texture, uv + vec2(-texel.x, -texel.y)) * 0.08;

    // Escurece levemente pra dar foco no modal
    vec3 col = mix(acc.rgb, vec3(0.0), darken);
    COLOR = vec4(col, 1.0);
}
