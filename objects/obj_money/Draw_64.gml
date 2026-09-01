font_enable_effects(font_money, true, {
    outlineEnable: true,
    outlineDistance: 10,
    outlineColour: c_maroon
});

draw_set_font(font_money);
draw_set_halign(fa_right);
draw_set_valign(fa_top);

// Verifica se bateu a meta do dia
var current_goal = obj_stages.STAGE_STATES[global.current_stage - 1].goal;
var goal_met = (money >= current_goal);
var hud_color = goal_met ? make_color_rgb(46, 204, 113) : c_white; // Verde Esmeralda Premium se bateu a meta, senão Branco

draw_set_colour(hud_color);

moneytext = "R$ " + string_format(money, 0, 2);

//var draw_x = display_get_gui_width();
var draw_x = display_get_gui_width() - 15;
var draw_y = 60;

if (shake > 0) {
    draw_x += random_range(-shake, shake);
    draw_y += random_range(-shake, shake);
}

// Desenha o dinheiro com a cor calculada
draw_text_outline_transformed(draw_x - 10, draw_y + 5, moneytext, hud_color, c_maroon, 1, 1, scale, scale, 0);

// Desenha Dia e Meta caso a stage_manager já tenha atualizado e salvo as posições
if (variable_global_exists("hud_stage_x")) {
    //TODO: importar fonte corretamente
    //draw_set_font(global.font_pixel_medium);
    draw_set_valign(fa_top);
    
    // Alinhamento à esquerda, igual ao layout original do RoomUI
    draw_set_halign(fa_left);
    
    // O Dia fica sempre branco ("Deixe o 'Dia X' em branco")
    var text_dia = "Dia " + string(global.current_stage);
    draw_text_outline(global.hud_stage_x, global.hud_stage_y, text_dia, c_white, c_maroon, 1, 1);
    
    var text_meta = "Meta: R$ " + string_format(current_goal, 0, 2);
    draw_text_outline(global.hud_goal_x, global.hud_goal_y, text_meta, hud_color, c_maroon, 1, 1);
    
    if (goal_met) {
        var text_w = string_width(text_meta);
        var text_h = string_height(text_meta);
        var line_y = global.hud_goal_y + text_h / 2;
        
        // Desenha a linha de riscado com contorno preto para visibilidade
        draw_set_color(c_maroon);
        draw_line_width(global.hud_goal_x - 2, line_y, global.hud_goal_x + text_w + 2, line_y, 4);
        
        // Desenha a linha interna na cor verde
        draw_set_color(hud_color);
        draw_line_width(global.hud_goal_x - 2, line_y, global.hud_goal_x + text_w + 2, line_y, 2);
    }
}