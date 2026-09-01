var hover = point_in_rectangle(mouse_x, mouse_y,
    x - largura/2, y - altura/2,
    x + largura/2, y + altura/2);

if (hover && mouse_check_button_pressed(mb_left)) {
    var _num = numerador;
    var _den = denominador;
    with (obj_orderNote) {
        if (!caindo && !entrando && flash_timer == 0) {
            if (numerador == _num && denominador == _den) {
                concluido   = true;
                cor_flash   = c_lime;
                flash_timer = 20; // pisca por 20 frames antes de cair
                var _s = slot;
                with (obj_orderManager) { slots_ocupados[_s] = false; }
                global.pontuacao += 100;
                break;
            }
        }
    }
}