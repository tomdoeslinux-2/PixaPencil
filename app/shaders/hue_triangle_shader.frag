#include <flutter/runtime_effect.glsl>

precision highp float;

uniform float u_hue;
uniform vec2 u_a;
uniform vec2 u_b;
uniform vec2 u_c;

out vec4 fragColor;

// Utility function from ChatGPT for converting hsv 2 rgb
vec3 hsv2rgb(float h, float s, float v) {
    float c = v * s;
    float x = c * (1.0 - abs(mod(h / 60.0, 2.0) - 1.0));
    float m = v - c;
    vec3 rgb;

    if (h < 60.0)      rgb = vec3(c, x, 0.0);
    else if (h < 120.0) rgb = vec3(x, c, 0.0);
    else if (h < 180.0) rgb = vec3(0.0, c, x);
    else if (h < 240.0) rgb = vec3(0.0, x, c);
    else if (h < 300.0) rgb = vec3(x, 0.0, c);
    else               rgb = vec3(c, 0.0, x);

    return rgb + vec3(m);
}

vec3 computeBarycentric(vec2 p, vec2 a, vec2 b, vec2 c) {
    vec2 v0 = b - a;
    vec2 v1 = c - a;
    vec2 v2 = p - a;

    float d00 = dot(v0, v0);
    float d01 = dot(v0, v1);
    float d11 = dot(v1, v1);
    float d20 = dot(v2, v0);
    float d21 = dot(v2, v1);

    float denom = d00 * d11 - (d01 * d01);
    float v = ((d11 * d20) - (d01 * d21)) / denom;
    float w = ((d00 * d21) - (d01 * d20)) / denom;
    float u = 1 - v - w;

    return vec3(u, v, w);
}

void main() {
    vec2 p = FlutterFragCoord().xy;

    vec3 bary = computeBarycentric(p, u_a, u_b, u_c);
    float u = bary.x;
    float v = bary.y;
    float w = bary.z;

    if (u >= 0 && v >= 0 && w >= 0) {
        float sat = u;
        float val = u + v;

        vec3 color = hsv2rgb(u_hue, sat, val);
        fragColor = vec4(color, 1.0);
    } else {
        discard;
    }
}