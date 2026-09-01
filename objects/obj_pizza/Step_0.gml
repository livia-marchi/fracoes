// Detecta os números (0–9)
for (var i = 0; i <= 9; i++) {
    if (keyboard_check_pressed(ord(string(i)))) {
        slice_count = i;
    }
}

slice_count = clamp(slice_count, 2, 9);

// Refaz o array se o count mudou
if (slice_count != last_slice_count) {
	slice_size = 360 / slice_count;
    slices = [];
    
    for (var i = 0; i < slice_count; i++) {
        slices[i] = { 
            visible: true,
            animated: false,
            onplate: false
        };
    }

    last_slice_count = slice_count;
	
	// Ativa o efeito visual de corte
	cut_scale = 1.12;
	cut_effect_timer = 15;
}

// Logic for pizza and peel animation
if (anim_state == "idle") {
    // Peel moves down and stays off-screen
    if (peel_y < room_height + 250) {
        peel_y += anim_speed;
    }
} else if (anim_state == "serving") {
    // Peel slides UP to pizza FIRST!
    if (peel_y > y) {
        peel_y -= anim_speed * 1.5; // Sobe mais rápido para pegar a pizza com agilidade
        if (peel_y < y) peel_y = y;
    } else {
        // Once peel reaches pizza, both go down
        y += anim_speed;
        peel_y += anim_speed;
        if (y > room_height + 300) {
            y = room_height + 300;
            peel_y = room_height + 300;
            
            // Transita para returning independentemente do prato!
            anim_state = "returning";
            
            // Limpa todas as fatias (nova pizza)
            for (var j = 0; j < array_length(slices); j++) {
                slices[j].visible = true;
                slices[j].onplate = false;
                slices[j].animated = false;
            }
        }
    }
} else if (anim_state == "returning") {
    // Both move up together
    y -= anim_speed;
    peel_y -= anim_speed;
    if (y <= original_y) {
        y = original_y;
        peel_y = original_y;
        anim_state = "idle";
    }
}

// Atualiza o efeito de corte
if (cut_effect_timer > 0) {
    cut_effect_timer--;
}
if (cut_scale > 1.0) {
    cut_scale -= 0.015; // Retorno suave ao tamanho original (1.0)
    if (cut_scale < 1.0) cut_scale = 1.0;
}

// Atualiza a interpolação de hover_offset de cada fatia para a pizza e prato
var mouse_dist_pizza = point_distance(x, y, mouse_x, mouse_y);
var mouse_ang_pizza = point_direction(x, y, mouse_x, mouse_y);
var hover_pizza_idx = -1;
if (anim_state == "idle" && mouse_dist_pizza <= sprite_width / 2) {
    hover_pizza_idx = floor(mouse_ang_pizza / slice_size);
}

var hover_plate_idx = -1;
if (instance_exists(obj_pizza_plate) && obj_pizza_plate.anim_state == "idle") {
    var px = obj_pizza_plate.x;
    var py = obj_pizza_plate.y;
    var mouse_dist_plate = point_distance(px, py, mouse_x, mouse_y);
    var mouse_ang_plate = point_direction(px, py, mouse_x, mouse_y);
    var plate_radius = (sprite_get_width(spr_plate) * obj_pizza_plate.image_xscale) / 2;
    if (mouse_dist_plate <= plate_radius) {
        hover_plate_idx = floor(mouse_ang_plate / slice_size);
    }
}

for (var i = 0; i < array_length(slices); i++) {
    if (!struct_exists(slices[i], "hover_offset")) {
        slices[i].hover_offset = 0.0;
    }
    
    var target_offset = 0.0;
    
    // Se a fatia estiver na pizza e a pizza estiver hovered
    if (slices[i].visible && !slices[i].animated && i == hover_pizza_idx) {
        target_offset = 12.0;
    }
    // Se a fatia estiver no prato e o prato estiver hovered
    else if (!slices[i].visible && slices[i].onplate && !slices[i].animated && i == hover_plate_idx) {
        target_offset = 12.0;
    }
    
    slices[i].hover_offset += (target_offset - slices[i].hover_offset) * 0.25;
}