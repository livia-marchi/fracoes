// Coleta frações das notas ativas
var ativas = [];
with (obj_orderNote) {
    if (!caindo) array_push(ativas, [numerador, denominador]);
}

// Monta decoys (frações que não estão ativas)
var decoys = [];
for (var i = 0; i < array_length(todas_fracoes); i++) {
    var ja_tem = false;
    for (var j = 0; j < array_length(ativas); j++) {
        if (todas_fracoes[i][0] == ativas[j][0]
        &&  todas_fracoes[i][1] == ativas[j][1]) {
            ja_tem = true; break;
        }
    }
    if (!ja_tem) array_push(decoys, todas_fracoes[i]);
}

// Embaralha decoys
for (var i = array_length(decoys) - 1; i > 0; i--) {
    var j = irandom(i);
    var tmp = decoys[i]; decoys[i] = decoys[j]; decoys[j] = tmp;
}

// Monta lista final de 4 opções
var opcoes = [];
for (var i = 0; i < array_length(ativas) && array_length(opcoes) < 4; i++)
    array_push(opcoes, ativas[i]);
for (var i = 0; i < array_length(decoys) && array_length(opcoes) < 4; i++)
    array_push(opcoes, decoys[i]);

// Embaralha opções
for (var i = array_length(opcoes) - 1; i > 0; i--) {
    var j = irandom(i);
    var tmp = opcoes[i]; opcoes[i] = opcoes[j]; opcoes[j] = tmp;
}

// Atribui aos botões
//for (var i = 0; i < 4; i++) {
 //   if (i < array_length(opcoes)) {
//        botoes[i].numerador   = opcoes[i][0];
 //       botoes[i].denominador = opcoes[i][1];
   // }
//}

alarm[1] = room_speed;