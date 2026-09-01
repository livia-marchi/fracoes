var show_hand = false;

// 1. Hover na Pizza
if (instance_exists(obj_pizza) && obj_pizza.anim_state == "idle") {
    var px = obj_pizza.x;
    var py = obj_pizza.y;
    var dist = point_distance(px, py, mouse_x, mouse_y);
    if (dist <= obj_pizza.sprite_width / 2) {
        // Encontra a direção e o índice do pedaço
        var ang = point_direction(px, py, mouse_x, mouse_y);
        var idx = floor(ang / obj_pizza.slice_size);
        if (idx >= 0 && idx < array_length(obj_pizza.slices)) {
            // Se o pedaço da pizza for visível, podemos clicar nele!
            if (obj_pizza.slices[idx].visible) {
                show_hand = true;
            }
        }
    }
}

// 2. Hover no Prato
if (!show_hand && instance_exists(obj_pizza_plate) && obj_pizza_plate.anim_state == "idle") {
    var plx = obj_pizza_plate.x;
    var ply = obj_pizza_plate.y;
    var dist = point_distance(plx, ply, mouse_x, mouse_y);
    var plate_radius = (sprite_get_width(spr_plate) * obj_pizza_plate.image_xscale) / 2;
    if (dist <= plate_radius) {
        // Encontra a direção e o índice do pedaço
        var ang = point_direction(plx, ply, mouse_x, mouse_y);
        var idx = floor(ang / obj_pizza.slice_size);
        if (idx >= 0 && idx < array_length(obj_pizza.slices)) {
            // Se o pedaço NÃO for visível na pizza, ele está no prato e podemos clicar nele para voltar!
            if (!obj_pizza.slices[idx].visible) {
                show_hand = true;
            }
        }
    }
}

// 3. Define o cursor
if (show_hand) {
    window_set_cursor(cr_handpoint);
} else {
    window_set_cursor(cr_default);
}
