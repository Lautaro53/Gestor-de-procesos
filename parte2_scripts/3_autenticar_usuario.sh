#!/bin/bash
# 3_autenticar_usuario.sh
# Autentica un usuario y contraseña contra el CSV generado por 2_descargar_usuarios.sh

CSV="usuarios.csv"

# Verificar que el archivo exista
if [ ! -f "$CSV" ]; then
    echo "Error: no se encontró el archivo $CSV. Ejecute primero 2_descargar_usuarios.sh."
    exit 1
fi

# Pedir usuario y contraseña si no se pasaron como argumentos
if [ -n "$1" ] && [ -n "$2" ]; then
    USER="$1"
    PASS="$2"
else
    read -p "Usuario: " USER
    read -sp "Contraseña: " PASS
    echo
fi

# Buscar coincidencia exacta en el CSV 
RESULT=$(awk -F',' -v u="$USER" -v p="$PASS" 'NR>1 && $1==u && $2==p {print $0}' "$CSV")

if [ -n "$RESULT" ]; then
    echo "Usuario autenticado correctamente."
    echo "Registro: $RESULT"
    exit 0
else
    echo "Credenciales incorrectas o usuario no registrado."
    exit 2
fi
