var start_x = x - (total_width / 2);
var start_y = y;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(font_fracao); // Usando a fonte existente para consistência

for (var i = min_slices; i <= max_slices; i++) {
    var bx = start_x + (i - min_slices) * (btn_width + btn_spacing);
    var by = start_y;
    
    var hover = point_in_rectangle(mouse_x, mouse_y, bx, by, bx + btn_width, by + btn_height);
    var is_selected = false;
    
    if (instance_exists(obj_pizza)) {
        if (obj_pizza.slice_count == i) is_selected = true;
    }
    
    // Cores
    var col_bg = c_white;
    if (is_selected) col_bg = make_color_rgb(255, 200, 100); // Laranja claro para selecionado
    else if (hover) col_bg = make_color_rgb(255, 220, 170); // Cinza para hover
    
    draw_set_color(col_bg);
    draw_roundrect_ext(bx, by, bx + btn_width, by + btn_height, 10, 10, false);
    
    draw_set_color(c_black);
    draw_roundrect_ext(bx, by, bx + btn_width, by + btn_height, 10, 10, true);
    
    draw_text(bx + btn_width/2, by + btn_height/2, string(i));
}
