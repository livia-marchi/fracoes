var hover = point_in_rectangle(mouse_x, mouse_y,
    x - largura/2, y - altura/2,
    x + largura/2, y + altura/2);

var cor = hover ? make_colour_rgb(255, 220, 80) : make_colour_rgb(255, 255, 255);
draw_set_color(cor);
draw_roundrect_ext(x - largura/2, y - altura/2, x + largura/2, y + altura/2, 10, 10, false);
draw_set_color(c_black);
draw_roundrect_ext(x - largura/2, y - altura/2, x + largura/2, y + altura/2, 10, 10, true);

draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(font_fracao);
draw_text(x, y - 18, string(numerador));
draw_line_width(x - 35, y + 2, x + 35, y + 2, 3);
draw_text(x, y + 22, string(denominador));