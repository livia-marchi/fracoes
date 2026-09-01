zpressed = keyboard_check_pressed(ord("Z"))
xpressed = keyboard_check_pressed(ord("X"))

if zpressed = true {
	money_add(2.00, true);
} else if xpressed = true {
	money_remove(2.00, true);
}

// Lógica de tremor (shake)
if (shake > 0) {
    shake -= 0.5;
} else {
    shake = 0;
}

// Lerp scale back to 1.0
scale = lerp(scale, 1.0, 0.1);

if(money < 0) {
	game_over();
}