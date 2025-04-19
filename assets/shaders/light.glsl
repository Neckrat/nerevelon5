extern vec3 color;
extern number time;

vec4 effect(vec4 vcolor, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texColor = Texel(tex, texture_coords);
    
    float mask = texColor.r;

    vec2 uv = texture_coords - 0.5;
    float dist = length(uv * 2.0);

    float t = time;
    
    float wave = sin((uv.x + uv.y) * 6.0 + t * 1.5) * 0.03;
    float ripple = sin(length(uv) * 20.0 - t * 2.0) * 0.02;
    float flicker = sin(t * 2.5) * 0.02;

    dist += wave + ripple + flicker;

    float intensity = 1.0 - smoothstep(0.0, 1.0, dist);
    intensity = pow(intensity, 2.0);

    float colorShift = sin(t * 3.0) * 0.1;
    vec3 flickerColor = color + vec3(colorShift, colorShift * 0.5, -colorShift * 0.3);

    vec3 finalColor = flickerColor * intensity * mask;

    return vec4(finalColor, mask * intensity);
}
