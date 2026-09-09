layer_set_visible("in_game_layer", false);
layer_set_visible("game_over_layer", false);

// verifica qual é a fase 
if (global.current_stage == 1) {
    reset_state();
} else {
    load_next_stage();
}