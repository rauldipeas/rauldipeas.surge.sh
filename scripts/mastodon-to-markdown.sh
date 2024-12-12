#!/bin/bash

# Configurações
ACCESS_TOKEN="$MASTODON_TOKEN"
MASTODON_INSTANCE="https://mastodon.social"
USERNAME="raul_dipeas"
OUTPUT_DIR="posts"
VIDEO_DIR="videos"
IMAGE_DIR="images"

# Criar diretórios para saída
mkdir -p "$OUTPUT_DIR" "$VIDEO_DIR" "$IMAGE_DIR"

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
    
    # Verificar se há anexo de mídia
    IMAGE_URL=$(echo "$POST" | jq -r '.media_attachments[0].url // ""')
    VIDEO_URL=$(echo "$POST" | jq -r '.media_attachments[] | select(.type=="video") | .url // ""')

    # Se houver vídeo, extrair um frame
    if [ -n "$VIDEO_URL" ]; then
      VIDEO_FILE="$VIDEO_DIR/$ID.mp4"
      IMAGE_FILE="$IMAGE_DIR/$ID-frame.jpg"
      
      # Baixar o vídeo
      curl -s -L -o "$VIDEO_FILE" "$VIDEO_URL"

      # Extrair um frame do meio do vídeo (usando ffmpeg)
      sudo apt install ffmpeg
      ffmpeg -i "$VIDEO_FILE" -vf "select='eq(n\,$(ffmpeg -i "$VIDEO_FILE" 2>&1 | grep -oP 'frame=\s*\K\d+' | wc -l)/2)'" -vsync vfr -q:v 2 "$IMAGE_FILE"

      # Usar o frame como imagem de capa
      IMAGE_URL="$IMAGE_FILE"
    fi

    # Determinar título a partir da primeira linha do conteúdo
    # Cortar o primeiro parágrafo (primeira linha vazia) e remover barras invertidas
    TITLE=$(echo "$CONTENT" | awk 'BEGIN{RS="";}{print $0; exit}' | sed 's/^\s*//;s/\s*$//' | sed 's/#.*//' | sed 's/\\/\//g')

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
