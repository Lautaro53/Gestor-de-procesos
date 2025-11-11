#!/bin/bash
# verificar_ejecutable.sh
# Comprueba si una ruta es un archivo ejecutable y lo ejecuta.

RUTA="$1"

# Verificar que se haya pasado un argumento
if [ -z "$RUTA" ]; then
    echo "Uso: $0 <ruta_del_archivo>"
    exit 1
fi

# Verificar que la ruta existe
if [ ! -e "$RUTA" ]; then
    echo "Error: la ruta '$RUTA' no existe."
    exit 2
fi

# Verificar que sea un archivo regular
if [ ! -f "$RUTA" ]; then
    echo "Error: '$RUTA' no es un archivo regular."
    exit 3
fi

# Verificar que sea ejecutable
if [ -x "$RUTA" ]; then
    echo "El archivo es ejecutable. Ejecutando..."
    "$RUTA"
else
    echo "El archivo existe pero no es ejecutable."
    exit 4
fi
