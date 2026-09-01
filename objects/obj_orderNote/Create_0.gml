slot       = -1;
numerador  = 1;
denominador = 2;
target_x   = x;
target_y   = y;
entrando   = true;

expiration_mult = obj_stages.STAGE_STATES[global.current_stage - 1].order_expiration_mult

tempo_total    = 30.0 * expiration_mult;
tempo_restante = tempo_total;

valor_base      = 10.00;
valor_bonus_max = 15.00;
valor_perda     = 5.00;

concluido = false;
falhado   = false;
caindo    = false;

vy      = 0;
rot     = 0;
rot_vel = choose(-1, 1) * (2 + random(2));
alpha   = 1.0;

cor_flash  = c_white;
flash_timer = 0;
scale_x = 1.0;
scale_y = 1.0;