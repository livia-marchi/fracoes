global.game_paused = false;

instance_activate_layer(layer_get_id("Instances"));

with (obj_pause) {
    instance_destroy();
}

load_next_stage();