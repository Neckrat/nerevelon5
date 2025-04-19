extern vec2 direction; // (1.0, 0.0) для X, (0.0, 1.0) для Y
extern number radius;  // радиус размытия

vec4 effect(vec4 vcolor, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 sum = vec4(0.0);
    float weightTotal = 0.0;

    for (int i = -10; i <= 10; i++) {
        float offset = float(i);
        float weight = exp(-offset * offset / (2.0 * radius * radius));
        vec2 shift = direction * offset / love_ScreenSize.xy;
        sum += Texel(tex, texture_coords + shift) * weight;
        weightTotal += weight;
    }

    return sum / weightTotal;
}