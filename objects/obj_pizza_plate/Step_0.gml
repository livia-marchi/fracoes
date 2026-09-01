// Detecta clique no prato (usando detecção global no Step para contornar a máscara de colisão pequena da instância)
if (mouse_check_button_pressed(mb_left)) {
    if (anim_state == "idle") {
        var _dist = point_distance(x, y, mouse_x, mouse_y);
        var _plate_radius = (sprite_get_width(spr_plate) * image_xscale) / 2;
        if (_dist <= _plate_radius) {
            var _ang = point_direction(x, y, mouse_x, mouse_y);
            var _slices = obj_pizza.slices;
            var _slice_size = obj_pizza.slice_size;
            var _slice_index = floor(_ang / _slice_size);
            
            if (!_slices[_slice_index].visible){
                _slices[_slice_index].visible = true;
                _slices[_slice_index].animated = true;
                instance_create_layer(x, y, "Animations", obj_pizza_slice, {slice_index : _slice_index});
            }
        }
    }
}

if (anim_state == "serving") {
    x += anim_speed;
    
    if (x >= room_width + 200) {
        anim_state = "returning";
        
        // O prato volta a partir da direita
        x = room_width + 200;
        y = original_y;
        
        // Garante que a pizza principal reinicie o ciclo e resete fatias
        if (instance_exists(obj_pizza)) {
            if (obj_pizza.anim_state == "serving") {
                obj_pizza.y = room_height + 300;
                obj_pizza.peel_y = room_height + 300;
                obj_pizza.anim_state = "returning";
            }
            
            // Reseta todas as fatias do prato para evitar vê-las voltando
            for (var j = 0; j < array_length(obj_pizza.slices); j++) {
                obj_pizza.slices[j].visible = true;
                obj_pizza.slices[j].onplate = false;
                obj_pizza.slices[j].animated = false;
            }
        }
        
        // Destruir fatias voando, caso existam
        with (obj_pizza_slice) {
            instance_destroy();
        }
    }
} else if (anim_state == "returning") {
    // Prato vem da direita para a esquerda
    x -= anim_speed;
    
    if (x <= original_x) {
        x = original_x;
        anim_state = "idle";
    }
}