varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_angle_start;
uniform float u_angle_end;
uniform float u_center_x;
uniform float u_center_y;

void main() {
    vec2 pos = gl_FragCoord.xy;
    vec2 dir = pos - vec2(u_center_x, u_center_y);
	
	
    float angle = degrees(atan(dir.y,dir.x));
	
	angle = angle * -1.0;

    if (angle < 0.0) angle += 360.0;

    if (angle < u_angle_start || angle > u_angle_end) {
        discard;
    }

    gl_FragColor = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;
}