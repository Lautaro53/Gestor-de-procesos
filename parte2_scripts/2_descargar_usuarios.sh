#!/bin/bash
# 2_descargar_usuarios.sh
# Descarga N usuarios aleatorios desde randomuser.me, guarda usuario y contraseña en CSV, descarga sus fotos y las envía al grupo de Telegram.

# Verificar argumento
if [ -z "$1" ]; then
    echo "Uso: $0 <cantidad_de_usuarios>"
    exit 1
fi

N=$1
CSV="usuarios.csv"
CARPETA_IMAGENES="imagenes_usuarios"

# Verificar variables de entorno de Telegram
if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "Error: debe exportar TELEGRAM_TOKEN y TELEGRAM_CHAT_ID antes de ejecutar."
    echo "Ejemplo:"
    echo "  export TELEGRAM_TOKEN=\"8389227483:AAH8nG_kJ0Ql31-17ynvSzLU-NYBqEyV-58\""
    echo "  export TELEGRAM_CHAT_ID=\"-1003403977612\""
    exit 1
fi

# Crear carpeta y archivo CSV
echo "usuario,contraseña,nombre,apellido,email,ciudad,imagen" >> "$CSV"

echo "Descargando $N usuarios desde randomuser.me..."
for ((i=1; i<=N; i++)); do
    DATA=$(curl -s "https://randomuser.me/api/")

    USERNAME=$(echo "$DATA" | jq -r '.results[0].login.username')
    PASSWORD=$(echo "$DATA" | jq -r '.results[0].login.password')
    NAME=$(echo "$DATA" | jq -r '.results[0].name.first')
    LAST=$(echo "$DATA" | jq -r '.results[0].name.last')
    EMAIL=$(echo "$DATA" | jq -r '.results[0].email')
    CITY=$(echo "$DATA" | jq -r '.results[0].location.city')
    IMG_URL=$(echo "$DATA" | jq -r '.results[0].picture.large')

    IMG_FILE="$CARPETA_IMAGENES/${USERNAME}_${LAST}.jpg"
    curl -s "$IMG_URL" -o "$IMG_FILE"

    echo "$USERNAME,$PASSWORD,$NAME,$LAST,$EMAIL,$CITY,$IMG_FILE" >> "$CSV"

    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendPhoto" \
         -F chat_id="${TELEGRAM_CHAT_ID}" \
         -F photo="@$IMG_FILE" \
         -F caption="Se creó el usuario ${USERNAME} (${NAME} ${LAST}), dejamos su foto para un reconocimiento rápido."

    echo "[$i/$N] Usuario ${USERNAME} procesado."
done

echo "Proceso completado. Datos guardados en $CSV."
