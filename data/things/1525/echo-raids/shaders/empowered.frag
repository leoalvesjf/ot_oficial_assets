// Original OT Tiozao Warden-empowered name highlight; independent of Forge stacks.
uniform sampler2D u_Tex0;
uniform vec4 u_Color;
uniform float u_Time;
uniform highp mat3 u_TextureMatrix;
varying highp vec2 v_TexCoord;

void main()
{
    vec4 texel = texture2D(u_Tex0, v_TexCoord);
    // Engine time is refreshed by Painter::draw; no Lua timer or game mechanics.
    float pulse = 0.5 + 0.5 * sin(mod(u_Time, 60.0) * 3.14159265);
    // Anchor phase to font-atlas pixels, never screen position: walking or
    // camera scrolling must not shift the highlight through the glyphs.
    float glyphX = v_TexCoord.x / max(abs(u_TextureMatrix[0][0]), 0.000001);
    float sweep = pow(0.5 + 0.5 * sin(glyphX * 0.18 - mod(u_Time, 60.0) * 4.1887902), 8.0);
    if (texel.a > 0.05) {
        float luminance = dot(texel.rgb, vec3(0.2126, 0.7152, 0.0722));
        vec3 ink = mix(vec3(0.42, 0.045, 0.55), vec3(1.0, 0.58, 0.94), luminance);
        ink *= 0.68 + 0.32 * pulse;
        ink = mix(ink, vec3(1.0, 0.85, 1.0), sweep * 0.85);
        gl_FragColor = vec4(ink, texel.a * u_Color.a);
    } else {
        vec2 dx = (u_TextureMatrix * vec3(1.0, 0.0, 0.0)).xy;
        vec2 dy = (u_TextureMatrix * vec3(0.0, 1.0, 0.0)).xy;
        float edge = max(max(texture2D(u_Tex0, v_TexCoord + dx).a, texture2D(u_Tex0, v_TexCoord - dx).a),
                         max(texture2D(u_Tex0, v_TexCoord + dy).a, texture2D(u_Tex0, v_TexCoord - dy).a));
        gl_FragColor = vec4(0.52, 0.04, 0.65, edge * (0.55 + 0.4 * pulse) * u_Color.a);
    }
}
