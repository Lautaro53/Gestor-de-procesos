#!/bin/bash
# 5_autenticar_y_notificar.sh
# Autentica un usuario con su contraseña y, si es correcto, envía su foto a Telegram notificando el inicio de sesión.

CSV="usuarios.csv"

# Verificar que el archivo exista
if [ ! -f "$CSV" ]; then
    echo "Error: no se encontró el archivo $CSV. Ejecute primero 2_descargar_usuarios.sh."
    exit 1
fi

# Verificar variables de entorno de Telegram
if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "Error: debe exportar TELEGRAM_TOKEN y TELEGRAM_CHAT_ID antes de ejecutar."
    exit 2
fi

# Pedir usuario y contraseña (si no vienen como argumentos)
if [ -n "$1" ] && [ -n "$2" ]; then
    USER="$1"
    PASS="$2"
else
    read -p "Usuario: " USER
    read -sp "Contraseña: " PASS
    echo
fi

# Buscar usuario y contraseña en el CSV
LINE=$(awk -F',' -v u="$USER" -v p="$PASS" 'NR>1 && $1==u && $2==p {print $0}' "$CSV")

if [ -z "$LINE" ]; then
    echo "Credenciales incorrectas o usuario no registrado."
    exit 3
fi

# Extraer campos del registro
IFS=',' read -r username password name last email city img <<< "$LINE"

# Enviar mensaje a Telegram con la foto
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendPhoto" \
     -F chat_id="${TELEGRAM_CHAT_ID}" \
     -F photo="@$img" \
     -F caption="El usuario ${username} (${name} ${last}) inició sesión correctamente desde ${city}."

echo "Notificación enviada a Telegram para el usuario ${username}."
exit 0
