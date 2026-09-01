#!/usr/bin/env bash
# =============================================================================
# rebuild_yyp.sh
# Reconstrói as seções dinâmicas de um arquivo .yyp do GameMaker a partir do disco.
#
# Seções reconstruídas:
#   - resources[]       — escaneado a partir de todos os arquivos *.yy no disco
#   - IncludedFiles[]   — escaneado a partir da pasta datafiles/
#   - RoomOrderNodes[]  — escaneado a partir da pasta rooms/, ordem preservada se possível
#
# Seções não modificadas:
#   - TextureGroups, AudioGroups, Options, tags, name, resourceVersion, etc.
#
# Uso:
#   bash rebuild_yyp.sh
#   bash rebuild_yyp.sh /caminho/para/o/projeto
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Funções auxiliares
# -----------------------------------------------------------------------------

log()  { echo "[rebuild_yyp] $*"; }
err()  { echo "[rebuild_yyp] ERROR: $*" >&2; exit 1; }
warn() { echo "[rebuild_yyp] WARNING: $*" >&2; }

# -----------------------------------------------------------------------------
# Localizar a raiz do projeto
# -----------------------------------------------------------------------------

if [ -n "${1:-}" ]; then
  PROJECT_ROOT="$1"
else
  # Se estiver dentro de um repositório git, usa a raiz dele. Caso contrário, usa o diretório atual.
  if git rev-parse --show-toplevel &>/dev/null 2>&1; then
    PROJECT_ROOT="$(git rev-parse --show-toplevel)"
  else
    PROJECT_ROOT="$(pwd)"
  fi
fi

cd "$PROJECT_ROOT" || err "Cannot cd into '$PROJECT_ROOT'"

# -----------------------------------------------------------------------------
# Encontrar o arquivo .yyp
# -----------------------------------------------------------------------------

YYP_FILE=""
while IFS= read -r -d '' f; do
  if [ -n "$YYP_FILE" ]; then
    err "Multiple .yyp files found in '$PROJECT_ROOT'. Please specify which project to use."
  fi
  YYP_FILE="$f"
done < <(find "$PROJECT_ROOT" -maxdepth 1 -name "*.yyp" -print0)

[ -z "$YYP_FILE" ] && err "No .yyp file found in '$PROJECT_ROOT'."
[ -f "$YYP_FILE" ] || err "Found .yyp path '$YYP_FILE' but it is not a regular file."

YYP_NAME="$(basename "$YYP_FILE")"
log "Arquivo do projeto encontrado: $YYP_NAME"

# Mantém um backup caso algo dê errado
BACKUP_FILE="${YYP_FILE}.bak"
cp "$YYP_FILE" "$BACKUP_FILE"

# -----------------------------------------------------------------------------
# Auxiliar: deriva o nome do recurso a partir do nome do arquivo .yy
#
# No GameMaker, o nome do recurso é SEMPRE idêntico ao nome do arquivo sem
# extensão. Ex: objects/obj_pizza/obj_pizza.yy -> "obj_pizza".
# Isso é mais simples e robusto do que tentar ler o campo "name" de dentro do
# arquivo, que contém muitos outros campos "name" aninhados (instâncias, grupos
# de textura, fontes, etc.) que causariam leituras incorretas.
# -----------------------------------------------------------------------------

resource_name_from_path() {
  basename "$1" .yy
}

# -----------------------------------------------------------------------------
# Construir resources[] — todos os arquivos *.yy exceto os tratados separadamente
# -----------------------------------------------------------------------------

log "Escaneando recursos .yy..."

RESOURCES_JSON=""
RESOURCE_COUNT=0

# Coleta todos os arquivos .yy, ordenados para saída determinística
mapfile -d '' YY_FILES < <(
  find "$PROJECT_ROOT" \
    -name "*.yy" \
    -not -name "*.*.yy" \
    -not -path "*/.git/*" \
    -not -path "*/datafiles/*" \
    -not -path "*/options/*" \
    -print0 \
  | sort -z
)

for yy_file in "${YY_FILES[@]}"; do
  # Obtém o caminho relativo a partir da raiz do projeto (barras normais, sem ./ no início)
  rel_path="${yy_file#"$PROJECT_ROOT"/}"

  # Deriva o nome do recurso diretamente do nome do arquivo
  name="$(resource_name_from_path "$yy_file")"

  if [ -z "$name" ]; then
    warn "Não foi possível extrair 'name' de '$rel_path' — ignorando."
    continue
  fi

  # Monta a entrada do recurso (formato GameMaker com vírgulas no final)
  entry="    {\"id\":{\"name\":\"${name}\",\"path\":\"${rel_path}\",},},"

  if [ -n "$RESOURCES_JSON" ]; then
    RESOURCES_JSON="${RESOURCES_JSON}
${entry}"
  else
    RESOURCES_JSON="${entry}"
  fi

  RESOURCE_COUNT=$((RESOURCE_COUNT + 1))
done

[ "$RESOURCE_COUNT" -eq 0 ] && err "Nenhum arquivo .yy encontrado — recusando gravar resources[] vazio."
log "$RESOURCE_COUNT recursos encontrados."

# -----------------------------------------------------------------------------
# Construir IncludedFiles[] — arquivos dentro de datafiles/
# -----------------------------------------------------------------------------

log "Escaneando arquivos incluídos..."

INCLUDEDFILES_JSON=""
INCLUDEDFILE_COUNT=0
DATAFILES_DIR="$PROJECT_ROOT/datafiles"

if [ -d "$DATAFILES_DIR" ]; then
  mapfile -d '' DATA_FILES < <(
    find "$DATAFILES_DIR" \
      -type f \
      -not -path "*/.git/*" \
      -print0 \
    | sort -z
  )

  for data_file in "${DATA_FILES[@]}"; do
    file_name="$(basename "$data_file")"
    # filePath é o diretório relativo que contém o arquivo (não o arquivo em si)
    rel_dir="$(dirname "${data_file#"$PROJECT_ROOT"/}")"

    entry="    {\"CopyToMask\":-1,\"filePath\":\"${rel_dir}\",\"resourceVersion\":\"1.0\",\"name\":\"${file_name}\",\"resourceType\":\"GMIncludedFile\",},"

    if [ -n "$INCLUDEDFILES_JSON" ]; then
      INCLUDEDFILES_JSON="${INCLUDEDFILES_JSON}
${entry}"
    else
      INCLUDEDFILES_JSON="${entry}"
    fi

    INCLUDEDFILE_COUNT=$((INCLUDEDFILE_COUNT + 1))
  done
fi

log "$INCLUDEDFILE_COUNT arquivos incluídos encontrados."

# -----------------------------------------------------------------------------
# Construir RoomOrderNodes[] — salas em ordem alfabética
# (Preservar uma ordem customizada exigiria um arquivo separado como fonte de verdade;
#  por ora ordenamos alfabeticamente para garantir determinismo)
# -----------------------------------------------------------------------------

log "Escaneando salas..."

ROOMORDER_JSON=""
ROOM_COUNT=0
ROOMS_DIR="$PROJECT_ROOT/rooms"

if [ -d "$ROOMS_DIR" ]; then
  mapfile -d '' ROOM_FILES < <(
    find "$ROOMS_DIR" \
      -name "*.yy" \
      -not -path "*/.git/*" \
      -print0 \
    | sort -z
  )

  for room_file in "${ROOM_FILES[@]}"; do
    rel_path="${room_file#"$PROJECT_ROOT"/}"
    name="$(resource_name_from_path "$room_file")"

    if [ -z "$name" ]; then
      warn "Não foi possível extrair 'name' da sala '$rel_path' — ignorando."
      continue
    fi

    entry="    {\"roomId\":{\"name\":\"${name}\",\"path\":\"${rel_path}\",},},"

    if [ -n "$ROOMORDER_JSON" ]; then
      ROOMORDER_JSON="${ROOMORDER_JSON}
${entry}"
    else
      ROOMORDER_JSON="${entry}"
    fi

    ROOM_COUNT=$((ROOM_COUNT + 1))
  done
fi

log "$ROOM_COUNT salas encontradas."

# -----------------------------------------------------------------------------
# Substituir as seções no arquivo .yyp usando awk
#
# Estratégia: o .yyp pode estar em formato compacto (tudo numa linha) ou
# formatado (multi-linha). Para lidar com ambos de forma robusta, lemos o
# arquivo inteiro como uma única string no awk, fazemos as substituições de
# seção com expressões regulares, e regravamos o resultado.
# -----------------------------------------------------------------------------

log "Reconstruindo $YYP_NAME..."

TEMP_FILE="${YYP_FILE}.tmp"

awk \
  -v resources_json="$RESOURCES_JSON" \
  -v includedfiles_json="$INCLUDEDFILES_JSON" \
  -v roomorder_json="$ROOMORDER_JSON" \
'
BEGIN { content = "" }

{ content = content $0 "\n" }

END {
  # Colapsa tudo em uma única linha para que os padrões de substituição
  # funcionem independentemente de o arquivo ser compacto ou multi-linha.
  # Guarda as quebras de linha originais como marcador temporário.
  gsub(/\n/, "@@NEWLINE@@", content)

  # Substitui cada seção gerenciada: captura a chave e os colchetes,
  # descarta o conteúdo original, injeta o novo.
  # Se o conteúdo for vazio, usa [] na mesma linha. Caso contrário, formata com indentação.
  if (resources_json == "") {
    gsub(/"resources"[[:space:]]*:[[:space:]]*\[[^]]*\]/, "\"resources\":[]", content)
  } else {
    gsub(/"resources"[[:space:]]*:[[:space:]]*\[[^]]*\]/, \
         "\"resources\":[\n" resources_json "\n  ]", content)
  }

  if (includedfiles_json == "") {
    gsub(/"IncludedFiles"[[:space:]]*:[[:space:]]*\[[^]]*\]/, "\"IncludedFiles\":[]", content)
  } else {
    gsub(/"IncludedFiles"[[:space:]]*:[[:space:]]*\[[^]]*\]/, \
         "\"IncludedFiles\":[\n" includedfiles_json "\n  ]", content)
  }

  if (roomorder_json == "") {
    gsub(/"RoomOrderNodes"[[:space:]]*:[[:space:]]*\[[^]]*\]/, "\"RoomOrderNodes\":[]", content)
  } else {
    gsub(/"RoomOrderNodes"[[:space:]]*:[[:space:]]*\[[^]]*\]/, \
         "\"RoomOrderNodes\":[\n" roomorder_json "\n  ]", content)
  }

  # Restaura as quebras de linha originais que não foram substituídas
  gsub(/@@NEWLINE@@/, "\n", content)

  printf "%s", content
}
' "$YYP_FILE" > "$TEMP_FILE"

# -----------------------------------------------------------------------------
# Validar: verificação básica de sanidade antes de sobrescrever o arquivo
# -----------------------------------------------------------------------------

if [ ! -s "$TEMP_FILE" ]; then
  rm -f "$TEMP_FILE"
  err "O arquivo de saída está vazio — algo deu errado. O .yyp original não foi alterado."
fi

# Conta as chaves para detectar corrupção grave
OPEN_BRACES=$(grep -o '{' "$TEMP_FILE" | wc -l)
CLOSE_BRACES=$(grep -o '}' "$TEMP_FILE" | wc -l)

if [ "$OPEN_BRACES" -ne "$CLOSE_BRACES" ]; then
  rm -f "$TEMP_FILE"
  err "Chaves desbalanceadas na saída ({: $OPEN_BRACES, }: $CLOSE_BRACES) — recusando sobrescrever. O .yyp original não foi alterado."
fi

# -----------------------------------------------------------------------------
# Gravar saída e limpar arquivos temporários
# -----------------------------------------------------------------------------

mv "$TEMP_FILE" "$YYP_FILE"
rm -f "$BACKUP_FILE"

log "Concluído."
log "  Recursos reconstruídos : $RESOURCE_COUNT"
log "  Arquivos incluídos     : $INCLUDEDFILE_COUNT"
log "  Nós de ordem de salas  : $ROOM_COUNT"