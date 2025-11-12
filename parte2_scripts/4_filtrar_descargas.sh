
#!/bin/bash
# descargar_y_filtrar.sh
# Descarga una página con wget y elimina los archivos si encuentra el token especificado.

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Uso: $0 <url> <token>"
    exit 1
fi

URL="$1"
TOKEN="$2"

CARPETA_BASE="descargas_web"
mkdir -p "$CARPETA_BASE"

DOMINIO=$(echo "$URL" | awk -F/ '{print $3}')    # extrae dominio (por ejemplo, www.ejemplo.com)
CARPETA="${CARPETA_BASE}/descarga_${DOMINIO}"

# Descarga con WGET
echo "Descargando contenido desde $URL ..."
mkdir -p "$CARPETA"
cd "$CARPETA" || exit 2

# -r: recursivo, -l1: solo nivel 1, -np: no subir directorios, -q: silencioso
wget -r -l1 -np -q "$URL"

echo "Descarga finalizada. Buscando token '$TOKEN' ..."

# Busca el Token
if grep -R "$TOKEN" . > /dev/null 2>&1; then
    echo "Token encontrado. Eliminando archivos descargados del dominio $DOMINIO..."
    cd ..
    rm -rf "$CARPETA"
    echo "Archivos eliminados correctamente."
else
    echo "Token no encontrado. Archivos conservados en la carpeta '$CARPETA/'."
fi
