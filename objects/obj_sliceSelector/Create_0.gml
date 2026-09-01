depth = -100;
min_slices = 2;
max_slices = 9;
btn_width = 50;
btn_height = 50;
btn_spacing = 15;

// Centralização baseada na quantidade de botões
var total_buttons = (max_slices - min_slices) + 1;
total_width = (total_buttons * btn_width) + ((total_buttons - 1) * btn_spacing);
