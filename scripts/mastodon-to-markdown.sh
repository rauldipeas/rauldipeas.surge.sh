#!/bin/bash

# Configurações
ACCESS_TOKEN="$MASTODON_TOKEN"
MASTODON_INSTANCE="https://mastodon.social"
USERNAME="raul_dipeas"
OUTPUT_DIR="posts"

# Criar diretório para saída
mkdir -p "$OUTPUT_DIR"

# Obter o ID do usuário
USER_ID=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "$MASTODON_INSTANCE/api/v1/accounts/lookup?acct=$USERNAME" | jq -r '.id')

if [ -z "$USER_ID" ]; then
  echo "Não foi possível obter o ID do usuário. Verifique suas configurações."
  exit 1
fi

# Variável para paginação
MAX_ID=""

while true; do
  # Buscar as postagens do usuário
  URL="$MASTODON_INSTANCE/api/v1/accounts/$USER_ID/statuses?limit=40"
  if [ -n "$MAX_ID" ]; then
    URL+="&max_id=$MAX_ID"
  fi

  POSTS=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" "$URL")

  # Verificar se há postagens
  if [ "$(echo "$POSTS" | jq -r 'length')" -eq 0 ]; then
    break
  fi

  # Processar cada postagem
  echo "$POSTS" | jq -c '.[]' | while read -r POST; do
    # Ignorar respostas
    IN_REPLY_TO_ID=$(echo "$POST" | jq -r '.in_reply_to_id')
    if [ "$IN_REPLY_TO_ID" != "null" ]; then
      continue
    fi

    # Extrair informações da postagem
    CONTENT=$(echo "$POST" | jq -r '.content' | sed 's/<[^>]*>//g')
    CREATED_AT=$(echo "$POST" | jq -r '.created_at' | sed 's/T.*//')
    TIME=$(echo "$POST" | jq -r '.created_at' | sed 's/.*T\(.*\)Z/\1/')
    ID=$(echo "$POST" | jq -r '.id')
    IMAGE_URL=$(echo "$POST" | jq -r '.media_attachments[0].url // ""')

    # Determinar título a partir da primeira linha do conteúdo
    TITLE=$(echo "$CONTENT" | awk 'NR==1 {print $0}' | sed 's/^\s*//;s/\s*$//')

    # Gerar arquivo Markdown
    FILENAME="$OUTPUT_DIR/$CREATED_AT-$ID.md"
    echo "---" > "$FILENAME"
    echo "title: \"$TITLE\"" >> "$FILENAME"
    echo "date: $CREATED_AT $TIME" >> "$FILENAME"
    if [ -n "$IMAGE_URL" ]; then
      echo "image: $IMAGE_URL" >> "$FILENAME"
    fi
    echo "---" >> "$FILENAME"
    echo "$CONTENT" >> "$FILENAME"

    echo "Postagem $ID salva em $FILENAME."
  done

  # Atualizar o max_id para a próxima página
  MAX_ID=$(echo "$POSTS" | jq -r '.[-1].id')

  # Se não houver mais postagens, sair do loop
  if [ -z "$MAX_ID" ]; then
    break
  fi

done

echo "Sincronização concluída!"
