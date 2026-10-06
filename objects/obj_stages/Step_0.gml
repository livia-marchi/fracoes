if (global.game_paused) {
    window_set_cursor(cr_default);
    exit;
}


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

// 3. Hover no botão de entregar pedido
if (!show_hand && instance_exists(global.serve_button)) {
    var btn = global.serve_button;

    if (point_in_rectangle(
        mouse_x, mouse_y,
        btn.x,
        btn.y,
        btn.x + 90,
        btn.y + 90
    )) {
        show_hand = true;
    }
}


// 4. Hover no seletor de fatias
if (!show_hand && instance_exists(obj_sliceSelector)) {
    var selector = obj_sliceSelector;

    var start_x = selector.x - (selector.total_width / 2);
    var start_y = selector.y;

    for (var i = selector.min_slices; i <= selector.max_slices; i++) {
        var bx = start_x + (i - selector.min_slices) *
                 (selector.btn_width + selector.btn_spacing);

        var by = start_y;

        if (point_in_rectangle(
            mouse_x,
            mouse_y,
            bx,
            by,
            bx + selector.btn_width,
            by + selector.btn_height
        )) {
            show_hand = true;
            break;
        }
    }
}

// 5. Define o cursor
if (show_hand) {
    window_set_cursor(cr_handpoint);
} else {
    window_set_cursor(cr_default);
}
