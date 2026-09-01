function next_stage() {
	if (global.current_stage < array_length(obj_stages.STAGE_STATES)) {
		update_money_stats_menu();
		global.current_stage = global.current_stage + 1;
		show_debug_message(global.current_stage);
		layer_set_visible("in_game_layer", true);
	} else {
		show_message("Você terminou a semana!");
		reset_state();
	}
}

function load_next_stage(){
		layer_set_visible("in_game_layer", false);
		obj_money.money = 0.00;
		obj_clock.reset_clock();
		obj_orderManager.clear_orders();
		obj_orderManager.start_orders();
		obj_pizza.reset_pizza();
		obj_pizza_plate.reset_plate();
		update_gui_stats();
		global.paused = false;
}

function game_over(){
	show_message("Voce perdeu!");
	reset_state();
}

function reset_state() {
	global.current_stage = 1;
	obj_money.money = 0.00;
	obj_money.total_money_week = 0.00;
	obj_pizza.reset_pizza();
	obj_pizza_plate.reset_plate();
	obj_clock.reset_clock();
	obj_orderManager.clear_orders();
	obj_orderManager.start_orders();
	global.paused = false;
}

function handle_time_up(){
	global.paused = true;
	obj_orderManager.clear_orders();
	
	if (obj_money.money >= obj_stages.STAGE_STATES[global.current_stage - 1].goal) {
		obj_money.total_money_week += obj_money.money;
		next_stage();
	} else {
		game_over();
	}
}

function update_money_stats_menu() {
		var _layer_panel = layer_get_flexpanel_node("in_game_layer");
		
		// Dinheiro do dia
		var _money_panel = flexpanel_node_get_child(_layer_panel, "money_day")
		var _money_struct = flexpanel_node_get_struct(_money_panel);
		var _money_text_el = _money_struct.layerElements[0].elementId;
		
		layer_text_text(_money_text_el, "Total do dia: R$ " + string(obj_money.money));
		
		// Total da semana
		var _money_total_panel = flexpanel_node_get_child(_layer_panel, "money_total")
		var _money_total_struct = flexpanel_node_get_struct(_money_total_panel);
		var _money_total_text_el = _money_total_struct.layerElements[0].elementId;
		
		layer_text_text(_money_total_text_el, "Total da semana: R$ " + string(obj_money.total_money_week));
}

function update_gui_stats(){
	var _layer_panel = layer_get_flexpanel_node("gui_layer");
	
	// Dia
	var _stage_panel = flexpanel_node_get_child(_layer_panel, "stage")
	var _stage_struct = flexpanel_node_get_struct(_stage_panel);
	var _stage_text_el = _stage_struct.layerElements[0].elementId;
	
	// Meta
	var _goal_panel = flexpanel_node_get_child(_layer_panel, "goal")
	var _goal_struct = flexpanel_node_get_struct(_goal_panel);
	var _goal_text_el = _goal_struct.layerElements[0].elementId;
	
	// Armazena a posição calculada do painel do Dia (apenas na primeira chamada para evitar colapso do flexpanel)
	if (!variable_global_exists("hud_stage_x") || global.hud_stage_x == 0) {
		var _stage_pos = flexpanel_node_layout_get_position(_stage_panel, false);
		global.hud_stage_x = _stage_pos.left;
		global.hud_stage_y = _stage_pos.top;
		global.hud_stage_w = _stage_pos.width;
		global.hud_stage_h = _stage_pos.height;
	}
	
	// Armazena a posição calculada do painel da Meta
	if (!variable_global_exists("hud_goal_x") || global.hud_goal_x == 0) {
		var _goal_pos = flexpanel_node_layout_get_position(_goal_panel, false);
		global.hud_goal_x = _goal_pos.left;
		global.hud_goal_y = _goal_pos.top;
		global.hud_goal_w = _goal_pos.width;
		global.hud_goal_h = _goal_pos.height;
	}
	
	// Oculta o texto original do RoomUI para desenharmos via código com contorno
	layer_text_text(_stage_text_el, "");
	layer_text_text(_goal_text_el, "");
}