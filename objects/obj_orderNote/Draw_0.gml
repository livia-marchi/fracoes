var _m = matrix_get(matrix_world);
matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, rot, scale_x, scale_y, 1));

var progresso = (tempo_total > 0) ? (tempo_restante / tempo_total) : 0;

// Cor do flash sobreposta ao sprite
var _blend = c_white;
if (caindo && falhado) {
    _blend = c_red;
}

draw_sprite_stretched_ext(spr_sticke, 0, -50, -50, 100, 100, _blend, alpha);

// Fração
draw_set_alpha(alpha);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(font_fracao);
draw_text(0, -20, string(numerador));
draw_line_width(-18, -2, 18, -2, 2);
draw_text(0, 14, string(denominador));

// Timer circular
var cx   = 0;
var cy   = 58;
var raio = 14;

var cor_timer;
if (progresso > 0.5)
    cor_timer = merge_colour(c_yellow, c_lime, (progresso - 0.5) * 2);
else if (progresso > 0.25)
    cor_timer = merge_colour(c_red, c_yellow, (progresso - 0.25) * 4);
else
    cor_timer = c_red;

// Background track (full circle outline)
draw_set_color(c_ltgray);
draw_set_alpha(alpha * 0.4);
var track_steps = 32;
var prev_tx = cx + dcos(0) * raio;
var prev_ty = cy - dsin(0) * raio;
for (var i = 1; i <= track_steps; i++) {
    var ang = (i / track_steps) * 360;
    var next_tx = cx + dcos(ang) * raio;
    var next_ty = cy - dsin(ang) * raio;
    draw_line_width(prev_tx, prev_ty, next_tx, next_ty, 5);
    prev_tx = next_tx;
    prev_ty = next_ty;
}

// Active timer arc
draw_set_alpha(alpha);
draw_set_color(cor_timer);
var passos = 32;
var prev_x = cx + dcos(90) * raio;
var prev_y = cy - dsin(90) * raio;
for (var i = 1; i <= passos; i++) {
    var ang = 90 - (i / passos) * 360 * progresso;
    var next_x = cx + dcos(ang) * raio;
    var next_y = cy - dsin(ang) * raio;
    draw_line_width(prev_x, prev_y, next_x, next_y, 5);
    prev_x = next_x;
    prev_y = next_y;
}

draw_set_alpha(1);
matrix_set(matrix_world, _m);