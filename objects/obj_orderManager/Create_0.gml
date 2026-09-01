global.pontuacao  = 0;
max_notas         = 4;
slots_ocupados    = [false, false, false, false];
spawn_intervalo   = room_speed * obj_stages.STAGE_STATES[global.current_stage - 1].spawn_interval;

// Posições dos 4 slots (fila horizontal)
var espaco = 110; // era 340
var ini    = 60;  // começa no canto esquerdo
slot_x     = [ini, ini + espaco, ini + espaco*2, ini + espaco*3];
slot_y     = 70;


// Pool de frações (carregado do estágio atual)
todas_fracoes = obj_stages.STAGE_STATES[global.current_stage - 1].fracoes;

// Cria os 4 botões de resposta
//botoes = array_create(4);
//var btn_esp = 190;
//var btn_ini = room_width / 2 - btn_esp * 1.5;
//for (var i = 0; i < 4; i++) {
 //   botoes[i] = instance_create_layer(btn_ini + i * btn_esp, room_height - 80, "Instances", obj_answerButton);
 //   botoes[i].btn_index = i;
//}

start_orders();

function start_orders() {
	spawn_intervalo   = room_speed * obj_stages.STAGE_STATES[global.current_stage - 1].spawn_interval;
	todas_fracoes     = obj_stages.STAGE_STATES[global.current_stage - 1].fracoes;
	alarm[0] = room_speed * 2; // primeira nota
	alarm[1] = room_speed;     // atualização dos botões
}

function clear_orders() {
	alarm[0] = -1;
	alarm[1] = -1;
	slots_ocupados    = [false, false, false, false];
	with (obj_orderNote) {
	    instance_destroy();
	}
}