var _m = matrix_get(matrix_world);
matrix_set(matrix_world, matrix_build(x, y, 0, 0, 0, angle, 1, 1, 1));
draw_sprite_stretched_ext(spr_sticke, 0, -size_w/2, -size_h/2, size_w, size_h, color, alpha);
matrix_set(matrix_world, _m);
