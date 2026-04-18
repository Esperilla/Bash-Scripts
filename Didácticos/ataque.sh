#!/bin/bash

# Script que identifica archivos nuevos o modificados en un directorio
# durante los ultimos segundos indicados por el usuario.

ayuda() {
    echo "Uso: $0 <directorio> <segundos>"
    echo "Descripción: Busca archivos en un directorio que han sido creados o modificados en los últimos segundos."
    exit 1
}

echo_error() {
    echo "$1" >&2
}

reportar_error() {
    local mensaje="$1";
    echo_error "$mensaje";
    ayuda;
    exit 1;
}

test "$1" == "-h" || test "$1" == "--help" && { ayuda; exit; }

DIR=$1
SEG=$2

# Verificación del directorio
if [ ! -d "$DIR" ]; then
    echo "Error: El directorio $DIR no existe"
    exit 1
fi

# Obtención del timestamp actual y calculo del inicio
TIEMPO_ACTUAL=$(date +%s)
TIEMPO_INICIO=$((TIEMPO_ACTUAL - SEG))

# Búsqueda de archivos modificados o creados en el rango de tiempo
find "$DIR" -type f -exec stat --format="%Y %Z %W %n" {} \; 2>/dev/null | while read MTIME CTIME BTIME PATH; do
    # Verificación de tiempo de creación
    if [ "$BTIME" != "0" ] && [ "$BTIME" -ge "$TIEMPO_INICIO" ]; then
        echo "$PATH:nuevo"
    # Si no hay tiempo de creación o no está en el rango, verifica modificación
    elif [ "$MTIME" -ge "$TIEMPO_INICIO" ]; then
        echo "$PATH:modificado"
    fi
done