// Centro da pizza
var cx = x;
var cy = y;

if (peel_y < room_height + 400) {
    // Desenha uma pá de pizza (placeholder) atrás da pizza
    var peel_radius = sprite_width * 0.55;
    var handle_w = 30;
    
    draw_set_color(make_color_rgb(180, 130, 80)); // Cor de madeira
    
    // Cabo da pá (vai até o fundo da tela)
    draw_roundrect(cx - handle_w/2, peel_y, cx + handle_w/2, peel_y + 1500, false);
    
    // Base da pá
    draw_circle(cx, peel_y, peel_radius, false);
    
    draw_set_color(c_white);
}

var _num_slices = array_length(slices);

for (var i = 0; i < _num_slices; i++)
{
	// Se o pedaço tiver escondido, não desenha ele
    if (!slices[i].visible || slices[i].animated) continue;

	// Pega os ângulos de início e fim do pedaço
    var ang1 = i * slice_size;
    var ang2 = (i + 1) * slice_size;

	// Calcula a direção e o deslocamento de hover (lift)
	var mid_ang = (ang1 + ang2) / 2;
	var offset_dist = struct_exists(slices[i], "hover_offset") ? slices[i].hover_offset : 0.0;
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
		
		draw_sprite_ext(sprite_index, image_index, shadow_cx, shadow_cy, cut_scale, cut_scale, 0, c_black, 0.25);
		
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
	
	// Desenha a fatia escalada pelo efeito de corte
    draw_sprite_ext(sprite_index, image_index, draw_cx, draw_cy, cut_scale, cut_scale, 0, c_white, 1);

    shader_reset();
}

// Configura o visual do corte (cor e espessura)
var line_color = c_red;
var line_width = 1;
if (cut_effect_timer > 0) {
    var t = cut_effect_timer / 15;
    line_color = merge_color(c_red, c_white, t);
    line_width = 1 + 3 * t; // Fica mais grosso e depois afina
}

draw_set_color(line_color);

var radius = sprite_width * 0.5 * cut_scale;

for (var i = 0; i < _num_slices; i++)
{
	
	var _prev_i = (i + _num_slices - 1) mod _num_slices;
	
	if (slices[i].onplate && slices[_prev_i].onplate) continue;
	if (!slices[i].visible && !slices[_prev_i].visible) continue;

    var ang = i * slice_size;

    var x2 = cx + lengthdir_x(radius, ang);
    var y2 = cy + lengthdir_y(radius, ang);
	
	// Desenha os cortes na pizza (com espessura se estiver no timer de corte)
    if (line_width > 1) {
        draw_line_width(cx, cy, x2, y2, line_width);
    } else {
        draw_line(cx, cy, x2, y2);
    }
}

