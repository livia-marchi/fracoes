/// _garantir_botao(numerador, denominador)
function _garantir_botao(num, den) {
    // Verifica se botão já existe
    with (obj_answerButton) {
        if (numerador == num && denominador == den) exit;
    }
    // Cria botão em posição aleatória no rodapé
    var bx = 100 + irandom(room_width - 200);
    var by = room_height - 80;
    var b = instance_create_layer(bx, by, "Instances", obj_answerButton);
    b.numerador   = num;
    b.denominador = den;
}

function check_and_complete_order() {
    if (!instance_exists(obj_pizza)) return;
    
    // 1. Identificar fraçao no prato
    var total_slices = obj_pizza.slice_count;
    var slices_on_plate = 0;
    for (var i = 0; i < array_length(obj_pizza.slices); i++) {
        if (obj_pizza.slices[i].onplate) {
            slices_on_plate++;
        }
    }
    
    if (slices_on_plate == 0) return; // Nada no prato
    
    var found = false;
    var best_note = noone;
    var min_time = 999999;
    
    // 2. Validar com os pedidos ativos (Priorizar o que tem menos tempo)
    with (obj_orderNote) {
        if (concluido || falhado || caindo || entrando) continue;
        
        // Multiplicação cruzada: a/b == c/d => a*d == c*b
        if (numerador * total_slices == slices_on_plate * denominador) {
            if (tempo_restante < min_time) {
                min_time = tempo_restante;
                best_note = id;
            }
        }
    }
    
    if (best_note != noone) {
        with (best_note) {
            // Entrega correta!
            concluido = true;
            flash_timer = 30; // 0.5s bounce
            
            // Spawn Confetti burst
            repeat (25) {
                instance_create_layer(x, y, "Instances", obj_confetti);
            }
            
            // Trigger Money UI bounce
            if (instance_exists(obj_money)) {
                obj_money.scale = 1.5;
            }
            
            // Cálculo do dinheiro baseado no tempo (balanço: não linear para facilitar)
            // Adicionamos +2 segundos de "lambuja" para compensar o tempo de animação/reação
            // Usamos raiz quadrada para o bônus cair devagar no início e rápido no fim
            var bonus_mult = sqrt(clamp((tempo_restante + 2.0) / tempo_total, 0, 1));
            var recompensa = valor_base + (valor_bonus_max * bonus_mult);
            
            money_add(recompensa, true);
            
            // Liberar slot no manager
            var _s = slot;
            with (obj_orderManager) { slots_ocupados[_s] = false; }
        }
        
        found = true;
        // Iniciar animação do prato (o prato se limpará ao sair da tela)
        with (obj_pizza_plate) {
            anim_state = "serving";
        }
        with (obj_pizza) {
            anim_state = "serving";
        }
    }
    
	if (!found){
		 // Entrega errada! (Perde um pouco de dinheiro)
            money_remove(3.00, true);
            
            // Iniciar animação do prato (o prato se limpará ao sair da tela)
            with (obj_pizza_plate) {
                anim_state = "serving";
            }
            with (obj_pizza) {
                anim_state = "serving";
            }
	}
}
