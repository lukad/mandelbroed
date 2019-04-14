#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
    return transform_projection * vertex_position;
}
#endif

#ifdef PIXEL
extern sampler2D palette;
extern vec2 center;
extern float scale;
extern int iter;
extern int width;
extern int height;

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 screen) {
    vec2 c;
    c.x = (float(width) / height) * (screen.x / width - 0.5) * scale - center.x;
    c.y = (screen.y / height - 0.5) * scale - center.y;

    int i;
    vec2 z = c;

    for (i = 0; i < iter; i++) {
        float x = (z.x * z.x - z.y * z.y) + c.x;
        float y = (z.y * z.x + z.x * z.y) + c.y;

        if ((x * x + y * y) > 4.0) {
            break;
        }

        z.x = x;
        z.y = y;
    }

    float palette_index = (i == iter ? 0.0 : float(i)) / 100.0;

    return Texel(palette, vec2(palette_index, 0));
}
#endif
