if (global.paused) {
	exit;
}

if (!acabou) {
    dt = delta_time / 1000000;

    time_left -= dt;

    if (time_left <= 0) {
        time_left = 0;
        acabou = true;

		handle_time_up();
    }
}