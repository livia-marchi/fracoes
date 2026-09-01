// Centro da pizza/prato
var cx = x;
var cy = y;

// Desenha o prato primeiro (aplicando a escala da instância para manter fidelidade de tamanho)
draw_sprite_ext(spr_plate, 0, cx, cy, image_xscale, image_yscale, 0, c_white, 1);

if (!instance_exists(obj_pizza)) exit;

var _slices = obj_pizza.slices;
var _num_slices = array_length(_slices);
var _slice_size = obj_pizza.slice_size;

for (var i = 0; i < _num_slices; i++)
{
	// Se o pedaço estiver visível na pizza principal ou estiver sendo animado, não desenha ele no prato
    if (_slices[i].visible || !_slices[i].onplate) continue;

	// Pega os ângulos de início e fim do pedaço
    var ang1 = i * _slice_size;
    var ang2 = (i + 1) * _slice_size;

	// Calcula a direção e o deslocamento de hover (lift)
	var mid_ang = (ang1 + ang2) / 2;
	var offset_dist = struct_exists(_slices[i], "hover_offset") ? _slices[i].hover_offset : 0.0;
	var shift_x = lengthdir_x(offset_dist, mid_ang);
	var shift_y = lengthdir_y(offset_dist, mid_ang);

	// 1. Desenha a mini sombra sob a fatia se estiver "subindo"
	if (offset_dist > 0.1) {
		var shadow_cx = cx + shift_x + 3;
		var shadow_cy = cy + shift_y + 6;
		
		shader_set(sh_slice);
		shader_set_uniform_f(u_angle_start, ang1);
		shader_set_uniform_f(u_angle_end, ang2);
		shader_set_uniform_f(u_center_x, shadow_cx);
		shader_set_uniform_f(u_center_y, shadow_cy);
		
		draw_sprite_ext(sprite_index, image_index, shadow_cx, shadow_cy, 1.0, 1.0, 0, c_black, 0.25);
		
		shader_reset();
	}

	// 2. Desenha a fatia na sua posição (deslocada pelo hover)
	var draw_cx = cx + shift_x;
	var draw_cy = cy + shift_y;

    shader_set(sh_slice);

	// Envia para o shader os ângulos inicial e final do pedaço, junto com as coordenadas do centro da pizza
    shader_set_uniform_f(u_angle_start, ang1);
    shader_set_uniform_f(u_angle_end, ang2);
    shader_set_uniform_f(u_center_x, draw_cx);
    shader_set_uniform_f(u_center_y, draw_cy);
	
    draw_sprite(sprite_index, image_index, draw_cx, draw_cy);

    shader_reset();
}

draw_set_color(c_red);

var radius = (sprite_get_width(spr_plate) * image_xscale) / 2;

for (var i = 0; i < _num_slices; i++)
{
	var _prev_i = (i + _num_slices - 1) mod _num_slices;
	
	if (!_slices[i].onplate && !_slices[_prev_i].onplate) continue;
	if (_slices[i].visible && _slices[_prev_i].visible) continue;
	
    var ang = i * _slice_size;

    var x2 = cx + lengthdir_x(radius, ang);
    var y2 = cy + lengthdir_y(radius, ang);
	
	// Desenha os cortes na pizza
    draw_line(cx, cy, x2, y2);
}