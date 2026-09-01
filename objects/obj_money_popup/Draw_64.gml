draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_font(font_money_popup);

draw_set_alpha(alpha);
//draw_text_color(x, y + y_offset, text, text_color, text_color, text_color, text_color, 1);
draw_text_outline(x, y + y_offset, text, text_color, c_black, 1.5, 1);
draw_set_alpha(1);