function reset_clock() {
	total_time = obj_stages.STAGE_STATES[global.current_stage - 1].total_time;
	time_left = total_time;
	acabou = false;
}

reset_clock();