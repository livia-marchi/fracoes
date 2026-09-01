if (anim_state != "idle") exit;

// Ignora clicks fora da pizza
var _dist = point_distance(x, y, mouse_x, mouse_y);
if (_dist > sprite_width / 2) exit;

// Encontra a direção do clique com relação ao centro da pizza
var _ang = point_direction(x, y, mouse_x, mouse_y);

// Pega o indice do pedaço
var _slice_index = floor(_ang / slice_size);

// Esconde o pedaço
if (slices[_slice_index].visible){
	slices[_slice_index].visible = false;
	slices[_slice_index].animated = true
	
	var inst = instance_create_layer (x, y, "Animations", obj_pizza_slice, {slice_index : _slice_index});
}