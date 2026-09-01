// Centro da pizza
var cx = x;
var cy = y;

if (!instance_exists(obj_pizza)) exit;

var _slices = obj_pizza.slices;
var _num_slices = array_length(_slices);
var _slice_size = obj_pizza.slice_size;


for (var i = 0; i < _num_slices; i++)
{
	// Se o pedaço estiver visível na pizza principal, não desenha ele no prato
    if (i  != slice_index) continue;

	// Pega os ângulos de início e fim do pedaço
    var ang1 = i * _slice_size;
    var ang2 = (i + 1) * _slice_size;
	
    shader_set(sh_slice);

	// Envia para o shader os ângulos inicial e final do pedaço, junto com as coordenadas do centro da pizza
    shader_set_uniform_f(u_angle_start, ang1);
    shader_set_uniform_f(u_angle_end, ang2);
    shader_set_uniform_f(u_center_x, cx);
    shader_set_uniform_f(u_center_y, cy);
	
    draw_sprite(sprite_index, image_index, cx, cy);

    shader_reset();
}