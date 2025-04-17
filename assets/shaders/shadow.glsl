extern vec2 light_dir;     // направление света, нормализованное
extern float flatten;      // насколько тень сплющена (0.2 - норм)
extern float softness;     // степень мягкости по краям

vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords)
{
    // Получаем оригинальный цвет спрайта
    vec4 tex_color = Texel(tex, tex_coords);

    // Преобразуем цвет в "тень"
    float alpha = tex_color.a;
    vec3 shadow_color = vec3(0.0); // черная тень

    // Модифицируем UV, чтобы проецировать вниз и вбок
    vec2 offset = tex_coords;
    offset.y -= tex_coords.y * flatten;              // сплющиваем вниз
    offset.x += tex_coords.y * flatten * light_dir.x; // сдвигаем в сторону

    vec4 proj = Texel(tex, offset);

    // Мягкость края тени (можно отключить, если не нужно)
    float edge_fade = smoothstep(0.0, softness, proj.a);

    return vec4(shadow_color, proj.a * edge_fade * 0.6); // альфа настраивается
}
