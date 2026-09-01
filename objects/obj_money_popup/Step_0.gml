y_offset -= 0.5;   // faz o popup subir
alpha -= 0.03;     // faz o popup desaparecer

if (alpha <= 0) {
    instance_destroy();
}