global.current_stage = 1

global.paused = false;

// Inicializa as fontes dinâmicas do pixel font (apenas uma vez)
if (!variable_global_exists("font_pixel_large")) {
    global.font_pixel_large = font_add("font_pixel.ttf", 36, false, false, 32, 128);
}
if (!variable_global_exists("font_pixel_medium")) {
    global.font_pixel_medium = font_add("font_pixel.ttf", 24, false, false, 32, 128);
}

//default_day_state = {
//	total_time: 120,
//	order_expiration_mult: 0.8,
// goal: 5.00
//}

STAGE_STATES = [
	// Dia 1 — ⭐ Fácil: Metade e quartos
	{
		total_time: 60,
		order_expiration_mult: 1.0,
		goal: 50,
		spawn_interval: 6.5,
		fracoes: [[1,2],[1,4],[3,4]]
	},
	// Dia 2 — ⭐ Fácil: + Terços
	{
		total_time: 60,
		order_expiration_mult: 0.85,
		goal: 65,
		spawn_interval: 5.5,
		fracoes: [[1,2],[1,3],[2,3],[1,4],[3,4]]
	},
	// Dia 3 — ⭐⭐ Médio: + Quintos
	{
		total_time: 60,
		order_expiration_mult: 0.8,
		goal: 80,
		spawn_interval: 4.8,
		fracoes: [[1,2],[1,3],[2,3],[1,4],[3,4],[2,5],[3,5]]
	},
	// Dia 4 — ⭐⭐ Médio: + Sextos
	{
		total_time: 60,
		order_expiration_mult: 0.75,
		goal: 95,
		spawn_interval: 4.2,
		fracoes: [[1,3],[2,3],[1,4],[3,4],[2,5],[3,5],[1,6],[5,6]]
	},
	// Dia 5 — ⭐⭐⭐ Difícil: + Oitavos
	{
		total_time: 60,
		order_expiration_mult: 0.7,
		goal: 105,
		spawn_interval: 3.8,
		fracoes: [[1,3],[2,3],[1,4],[3,4],[2,5],[3,5],[1,6],[5,6],[1,8],[3,8]]
	},
	// Dia 6 — ⭐⭐⭐ Difícil: Mix completo
	{
		total_time: 60,
		order_expiration_mult: 0.65,
		goal: 115,
		spawn_interval: 3.4,
		fracoes: [[1,2],[1,3],[2,3],[1,4],[3,4],[2,5],[3,5],[1,6],[5,6],[1,8],[3,8]]
	},
	// Dia 7 — ⭐⭐⭐⭐ Desafio final
	{
		total_time: 60,
		order_expiration_mult: 0.55,
		goal: 130,
		spawn_interval: 3.0,
		fracoes: [[1,2],[1,3],[2,3],[1,4],[3,4],[2,5],[3,5],[1,6],[5,6],[1,8],[3,8]]
	}
]

layer_set_visible("in_game_layer", false);

update_gui_stats();