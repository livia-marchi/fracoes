draw_self();

draw_set_font(font_clock);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

text_color = c_olive;
text = "" ;

total_sec = floor(time_left);
minutes = total_sec div 60;
secconds = total_sec mod 60;

// formatação 00:00
if secconds < 600 { text += "0"}
text += string_format(minutes, 0, 0) + ":" ;
if secconds < 10 { text += "0"}
text +=  string_format(secconds, 0, 0);


centerX = x - sprite_xoffset + sprite_width / 2;
centerY = y - sprite_yoffset + sprite_height / 2;

draw_text_color(centerX, centerY, text, text_color, text_color, text_color, text_color, 1)