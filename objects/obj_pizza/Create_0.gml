function reset_pizza() {
	slice_count = 4;
	slice_size = 360 / slice_count
	last_slice_count = slice_count;
	slices = [];
	slice_animated = [];
	for (var i = 0; i < slice_count; i++) {
	    slices[i] = {
	        visible: true,
			animated: false,
			onplate: false
	    };
	}

	u_angle_start = shader_get_uniform(sh_slice, "u_angle_start");
	u_angle_end   = shader_get_uniform(sh_slice, "u_angle_end");
	u_center_x    = shader_get_uniform(sh_slice, "u_center_x");
	u_center_y    = shader_get_uniform(sh_slice, "u_center_y");
}

reset_pizza();

original_x = x;
original_y = y;
anim_state = "idle";
anim_speed = 25;
peel_y = room_height + 250;

// Efeito de Cortado
cut_scale = 1.0;
cut_effect_timer = 0;