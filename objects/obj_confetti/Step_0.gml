angle += angle_speed;
alpha -= fade_speed;

if (alpha <= 0 || y > room_height + 50) {
    instance_destroy();
}
