// continua o jogo
global.game_paused = false;

with (obj_pause_blocker) {
    instance_destroy();
}

load_next_stage();
