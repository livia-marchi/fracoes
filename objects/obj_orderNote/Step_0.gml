if (entrando) {
    x += (target_x - x) * 0.12;
    y += (target_y - y) * 0.12;
    if (abs(x - target_x) < 2 && abs(y - target_y) < 2) {
        x = target_x;
        y = target_y;
        entrando = false;
    }
    exit;
}

if (caindo) {
    vy    += 1.5;
    y     += vy;
    rot   += rot_vel;
    alpha -= 0.03;
    if (alpha <= 0) instance_destroy();
    exit;
}

// Flash/Bounce ao acertar
if (flash_timer > 0) {
    flash_timer--;
    var t = (30 - flash_timer) / 30; // 0 to 1
    // Scale bounce formula: starts at 1, goes up to 1.4, settles back to 1
    scale_x = 1.0 + 0.4 * sin(t * pi);
    scale_y = scale_x;
    // Wiggle rotation
    rot = 12 * sin(t * pi * 2);
    
    if (flash_timer <= 0) {
        caindo = true;
        rot_vel = choose(-1, 1) * (5 + random(5)); // spin faster as it falls!
        vy = -5; // hop up slightly before falling
    }
    exit;
}

tempo_restante -= delta_time / 1000000;
if (tempo_restante <= 0) {
    tempo_restante = 0;
    falhado    = true;
    cor_flash  = c_red;
    caindo     = true;
    var _s = slot;
    with (obj_orderManager) { slots_ocupados[_s] = false; }
	money_remove(valor_perda, true);
}