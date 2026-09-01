function reset_plate() {
	u_angle_start = shader_get_uniform(sh_slice, "u_angle_start");
	u_angle_end   = shader_get_uniform(sh_slice, "u_angle_end");
	u_center_x    = shader_get_uniform(sh_slice, "u_center_x");
	u_center_y    = shader_get_uniform(sh_slice, "u_center_y");

	original_x = x;
	original_y = y;
	anim_state = "idle"; // idle, serving, returning
	anim_speed = 18;
}

reset_plate();