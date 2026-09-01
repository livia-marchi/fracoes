function money_add(val, mk_popup){
	if mk_popup {
		var inst = instance_create_layer(display_get_gui_width() - 30, 90, "Animations", obj_money_popup);
		inst.text = "+R$ " + string_format(val, 0, 2);
		inst.text_color = c_lime;
	}
	
	obj_money.money += val;
}

function money_remove(val, mk_popup){
	if mk_popup = true {
		var inst = instance_create_layer(display_get_gui_width() - 30, 90, "Animations", obj_money_popup)
		inst.text = "-R$ " + string_format(val, 0, 2);
		inst.text_color = c_red;
	}
	
	obj_money.money -= val;
    obj_money.shake = 5; // Adiciona a tremida
}