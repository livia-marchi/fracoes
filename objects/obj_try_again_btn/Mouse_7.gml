global.game_paused = false;

instance_activate_layer(layer_get_id("Instances"));

with (obj_pause) {
    instance_destroy();
}

layer_set_visible("in_game_layer", false);
layer_set_visible("game_over_layer", false);
layer_set_visible("end_of_the_week_layer", false);

// verifica qual é a fase 
if (global.current_stage == 1 || global.current_stage == 7) {
    reset_state();
} else {
    load_next_stage();
}