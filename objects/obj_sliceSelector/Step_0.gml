if (mouse_check_button_pressed(mb_left)) {
    var start_x = x - (total_width / 2);
    var start_y = y;
    
    for (var i = min_slices; i <= max_slices; i++) {
        var bx = start_x + (i - min_slices) * (btn_width + btn_spacing);
        var by = start_y;
        
        if (point_in_rectangle(mouse_x, mouse_y, bx, by, bx + btn_width, by + btn_height)) {
            if (instance_exists(obj_pizza)) {
                obj_pizza.slice_count = i;
            }
            break;
        }
    }
}
