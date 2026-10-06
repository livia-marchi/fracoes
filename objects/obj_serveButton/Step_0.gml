var hover = point_in_rectangle(
    mouse_x, mouse_y,
    x,
    y,
    x + 90,
    y + 90
);

if (hover && mouse_check_button_pressed(mb_left)) {
    check_and_complete_order();
}