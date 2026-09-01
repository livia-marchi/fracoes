# Fração de Pizza

Jogo educativo em GameMaker em que o jogador atende pedidos de pizza representando frações: corta a pizza em partes, monta a fração pedida no prato e entrega antes que o tempo acabe.

## Requisitos

- **GameMaker IDE** `2024.1400.5.1065` (versão registrada no `fracao-de-pizza.yyp`)
- Projeto principal: `fracao-de-pizza.yyp`
- Sala de jogo: `rooms/SandboxPizza`

## Loop de jogo

O jogo simula uma semana de trabalho em uma pizzaria, dividida em **7 dias** (estágios). Cada dia tem:

1. Um **tempo limite** (`total_time`, em segundos)
2. Uma **meta de dinheiro** (`goal`, em reais)
3. Um conjunto de **frações permitidas** nos pedidos (`fracoes`)
4. Parâmetros de dificuldade: intervalo entre pedidos (`spawn_interval`) e tempo de expiração dos pedidos (`order_expiration_mult`)

Fluxo de uma rodada:

1. Pedidos aparecem na fila superior (`obj_orderNote`, até 4 simultâneos)
2. O jogador escolhe em quantas fatias cortar a pizza (`obj_sliceSelector`, de 2 a 9)
3. Clica nas fatias da pizza para enviá-las ao prato (animação via `obj_pizza_slice`)
4. Clica em **Servir** (`obj_serveButton`) para validar a fração montada no prato
5. Ao fim do tempo (`obj_clock`), compara o dinheiro ganho com a meta do dia
6. Se atingiu a meta, exibe o menu entre dias (`RoomUI` → `in_game_layer`) e avança; caso contrário, game over

A configuração de todos os dias está em `objects/obj_stages/Create_0.gml`, no array `STAGE_STATES`. A lógica de progressão fica em `scripts/stage_manager/stage_manager.gml`.

## Arquitetura principal

### Objetos controladores

| Objeto | Responsabilidade |
|---|---|
| `obj_stages` | Define `STAGE_STATES`, controla cursor de mão sobre pizza/prato, inicializa fontes dinâmicas |
| `obj_orderManager` | Spawna pedidos (`Alarm_0`), gerencia 4 slots e pool de frações do estágio atual |
| `obj_clock` | Contagem regressiva do dia; chama `handle_time_up()` ao zerar |
| `obj_money` | Saldo do dia, HUD (Draw GUI), feedback visual (shake/scale) |
| `obj_canvas` | Redimensionamento da janela/navegador (target HTML5) |

### Mecânica da pizza

O estado das fatias é centralizado em **`obj_pizza.slices[]`**. Cada fatia é um struct:

```gml
{ visible: bool, onplate: bool, animated: bool, hover_offset: float }
```

- `visible = true` → fatia está na pizza
- `visible = false`, `onplate = true` → fatia está no prato
- `animated = true` → fatia em trânsito (`obj_pizza_slice`)

Campos importantes de `obj_pizza`:

- `slice_count` — número de divisões (2–9)
- `slice_size` — `360 / slice_count`
- `anim_state` — `"idle"`, `"serving"` ou `"returning"` (animação de entrega com a pá)

**Interações:**

- Clique na pizza (`Mouse_4`) → remove fatia e cria `obj_pizza_slice` voando para o prato
- Clique no prato (`obj_pizza_plate/Step_0`) → devolve fatia do prato para a pizza
- Seletor de fatias (`obj_sliceSelector`) → altera `slice_count` e recria o array de fatias

`obj_pizza_plate` desenha as fatias que estão no prato reutilizando o mesmo shader e lendo `obj_pizza.slices`.

### Shader de fatias (`sh_slice`)

Localizado em `shaders/sh_slice/`. Recorta a sprite circular da pizza por ângulo (fatia em forma de pizza). Usado em:

- `obj_pizza/Draw_0.gml`
- `obj_pizza_plate/Draw_0.gml`
- `obj_pizza_slice/Draw_0.gml`

Uniforms: `u_angle_start`, `u_angle_end`, `u_center_x`, `u_center_y`.

Ao mudar `slice_count`, a pizza exibe um efeito visual de corte (`cut_scale`, `cut_effect_timer`).

### Sistema de pedidos

**Spawn** (`obj_orderManager/Alarm_0.gml`): escolhe slot livre, sorteia fração do pool do estágio e cria `obj_orderNote` com animação de entrada.

**Validação de entrega** (`scripts/orderManager/orderManager.gml` → `check_and_complete_order()`):

- Conta fatias no prato (`onplate = true`)
- Compara com pedidos ativos via multiplicação cruzada: `a/b == c/d` ⟺ `a*d == c*b`
- Prioriza o pedido com menos tempo restante
- Recompensa proporcional ao tempo (`valor_base + valor_bonus_max * sqrt(...)`)
- Entrega errada: `-R$ 3,00` e animação de saída do prato
- Pedido expirado: `-R$ 5,00` (`obj_orderNote/Step_0.gml`)

### Interface (RoomUI)

`roomui/RoomUI/RoomUI.yy` define duas camadas FlexPanel:

- **`gui_layer`** — posições de referência para "Dia X" e "Meta: R$ ...". O texto real é desenhado por código em `obj_money/Draw_64.gml` (com contorno), usando coordenadas obtidas por `update_gui_stats()` em `stage_manager.gml`.
- **`in_game_layer`** — menu exibido ao completar um dia (totais e botão "Próximo dia"). Inicia oculta; `next_stage()` a torna visível. O botão `obj_next_day_btn` chama `load_next_stage()`.

## Scripts utilitários

| Script | Função |
|---|---|
| `stage_manager` | Progressão de dias, game over, reset, atualização de HUD e menu |
| `orderManager` | Validação de entregas e helper `_garantir_botao()` |
| `money_functions` | `money_add()` e `money_remove()` com popups (`obj_money_popup`) |
| `draw_text_outline_color` | Texto com contorno para o HUD |

## Camadas da sala

| Camada | Conteúdo |
|---|---|
| `GameManagers` | `obj_stages` |
| `Instances` | pizza, prato, relógio, dinheiro, pedidos, botões |
| `Animations` | fatias voando, popups de dinheiro, confete |
| `background_objs` | mesa, tábua de corte |
| `Background` | `spr_new_background` |

## Ferramentas de desenvolvimento

### `rebuild-ypp.sh`

Reconstrói seções dinâmicas do `.yyp` a partir dos arquivos no disco:

- `resources[]` — todos os `*.yy`
- `IncludedFiles[]` — arquivos em `datafiles/`
- `RoomOrderNodes[]` — salas em `rooms/`

Útil quando o `.yyp` fica dessincronizado após merge ou edição manual.

### Arquivos incluídos

- `datafiles/font_pixel.ttf` — fonte pixel carregada dinamicamente em `obj_stages` (`global.font_pixel_large`, `global.font_pixel_medium`), ainda não aplicada no HUD (ver pendências).

## Código legado / alternativo

Existe um fluxo paralelo com **`obj_answerButton`** (botões de fração na parte inferior da tela) que permite marcar pedidos clicando diretamente na fração, sem montar a pizza. Esse fluxo está **parcialmente implementado e desativado**:

- Criação fixa de botões comentada em `obj_orderManager/Create_0.gml`
- Atualização de opções comentada em `obj_orderManager/Alarm_1.gml`
- `_garantir_botao()` existe em `orderManager.gml`, mas **não é chamada** em nenhum lugar
- `global.pontuacao` é incrementada pelos botões, mas não influencia o fluxo principal (dinheiro/meta)

Decidir se esse modo será removido, reativado como alternativa pedagógica ou integrado ao fluxo principal.

## Atalhos de debug (remover ou proteger em produção)

| Local | Comportamento |
|---|---|
| `obj_pizza/Step_0.gml` | Teclas `0`–`9` alteram `slice_count` diretamente |
| `obj_money/Step_0.gml` | `Z` adiciona R$ 2,00; `X` remove R$ 2,00 |

## Pendências e pontos de polimento

Prioridades sugeridas para quem continuar o projeto:

### Menus e fluxo de telas

1. **Menu inicial** — não existe hoje; o jogo inicia direto na sala `SandboxPizza`. Criar tela de abertura (título, instruções resumidas, botão jogar) via RoomUI ou sala dedicada
2. **Menu de pausa** — `global.paused` já é usado ao fim do dia (`handle_time_up()`), mas não há pausa durante a partida. Implementar overlay de pausa (ESC ou botão), congelando relógio, spawn de pedidos e interações
3. **Menu de próximo dia** — base em `in_game_layer` (`obj_next_day_btn`, `update_money_stats_menu()`), mas ainda rudimentar. Polir layout, textos, transições e feedback visual antes de chamar `load_next_stage()`
4. **UI de fim de jogo** — `show_message()` em `game_over()` e ao completar a semana; substituir por telas no RoomUI (vitória, derrota, resumo da semana)

### Gameplay e conteúdo

5. **Fonte pixel no HUD** — TODO em `obj_money/Draw_64.gml`; fonte já carregada em `obj_stages`
6. **Pá de pizza** — desenhada como placeholder (`draw_circle`/`draw_roundrect`) em `obj_pizza/Draw_0.gml`; falta sprite definitiva
7. **Botões de resposta** — decidir destino do `obj_answerButton` (remover ou finalizar)
8. **Remover atalhos de debug** — teclado em `obj_pizza` e `obj_money`
9. **Balanceamento** — metas, recompensas e tempos em `STAGE_STATES` e `obj_orderNote` (valores base/bônus/perda)
10. **`obj_init`** — objeto existe, mas não está instanciado na sala; inicialização real ocorre em `obj_stages` e `obj_orderManager`
11. **Assets** — sprites de fundo, mesa e UI já existem, mas há espaço para refinamento visual e feedback sonoro (nenhum áudio implementado)
12. **Testes em HTML5** — `obj_canvas` trata resize; validar exportação web se for um dos alvos finais

### Leaderboard e acompanhamento pedagógico

13. **Leaderboard** — não implementado. Definir o que entra no placar (ex.: total da semana, dias concluídos, tempo total, erros) e onde exibir (tela final, menu separado)
14. **Envio de score para servidor** — após o fim da partida (vitória ou derrota), enviar resultado a um backend para professores acompanharem o avanço dos alunos. Pontos a definir:
    - **Payload** — identificador do aluno/turma, score, estágio máximo, timestamp, duração da sessão
    - **Transporte** — em HTML5, `http_request()` para API REST; validar CORS e HTTPS no servidor
    - **Autenticação** — token, código de sala ou login simples conforme o ambiente escolar
    - **Offline/falha** — fila local ou mensagem ao jogador se o envio falhar
    - **Privacidade** — alinhar com LGPD e política da instituição (dados mínimos, consentimento)

Não há código de rede no projeto atualmente; a integração provavelmente envolverá um script dedicado (ex.: `score_api`) chamado a partir de `stage_manager.gml` nos fluxos de `game_over()`, `next_stage()` (último dia) e/ou tela de resultados.

## Estrutura de pastas

```
objects/          # Objetos do jogo (controller, pizza, orders, ui, menu)
scripts/          # Lógica compartilhada (stage_manager, orderManager, etc.)
shaders/sh_slice/ # Shader de recorte angular das fatias
rooms/            # Salas
roomui/           # Layout FlexPanel da interface
sprites/          # Arte do jogo
fonts/            # Fontes do projeto
datafiles/        # Arquivos incluídos em runtime (font_pixel.ttf)
options/          # Configurações de exportação por plataforma
git-hooks/        # Hooks versionados (post-merge → rebuild-ypp.sh)
```

## Referência rápida: onde alterar o quê

| Objetivo | Arquivo |
|---|---|
| Dificuldade por dia | `objects/obj_stages/Create_0.gml` → `STAGE_STATES` |
| Regras de entrega e recompensa | `scripts/orderManager/orderManager.gml` |
| Tempo/valor dos pedidos | `objects/obj_orderNote/Create_0.gml` |
| Progressão entre dias | `scripts/stage_manager/stage_manager.gml` |
| Aparência das fatias | `shaders/sh_slice/` + Draw events de pizza/prato/fatia |
| Layout do HUD e menu | `roomui/RoomUI/RoomUI.yy` + `obj_money/Draw_64.gml` |
| Menu entre dias | `roomui/RoomUI/RoomUI.yy` → `in_game_layer` + `obj_next_day_btn` |
| Pausa e fluxo de telas | `global.paused` em `stage_manager.gml`; menus ainda não existem |
| Envio de score (futuro) | `stage_manager.gml` (fim de partida) + script/API dedicado |
| Sincronizar `.yyp` com o disco | `./rebuild-ypp.sh` |
