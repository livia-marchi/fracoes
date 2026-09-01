draw_set_alpha(1);
var hover = point_in_rectangle(mouse_x, mouse_y,
    x - largura/2, y - altura/2,
    x + largura/2, y + altura/2);

var cor = hover ? make_colour_rgb(100, 255, 100) : make_colour_rgb(50, 200, 50);
draw_set_color(cor);
draw_roundrect_ext(x - largura/2, y - altura/2, x + largura/2, y + altura/2, 10, 10, false);
draw_set_color(c_white);
draw_roundrect_ext(x - largura/2, y - altura/2, x + largura/2, y + altura/2, 10, 10, true);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(font_fracao);
draw_text(x, y, ">");