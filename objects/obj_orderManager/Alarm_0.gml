// Acha slot livre
var slot_livre = -1;
for (var i = 0; i < 4; i++) {
    if (!slots_ocupados[i]) { slot_livre = i; break; }
}

if (slot_livre != -1) {
    slots_ocupados[slot_livre] = true;
    var f    = todas_fracoes[irandom(array_length(todas_fracoes) - 1)];
    var nota = instance_create_layer(-200, slot_y, "Instances", obj_orderNote);
    nota.slot        = slot_livre;
    nota.target_x    = slot_x[slot_livre];
    nota.target_y    = slot_y;
    nota.numerador   = f[0];
    nota.denominador = f[1];
}

alarm[0] = spawn_intervalo;