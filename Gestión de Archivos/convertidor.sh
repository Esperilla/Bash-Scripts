#!/bin/bash

# Script que convierte archivos de una extension a otra dentro de un
# directorio, usando la herramienta `convert`.

ayuda() {
    echo "$(basename $0) parametro"
    echo "Regresa el último parametro pasodo al script"
    echo "Uso: $(basename $0) parametro"
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

# Guardo los argumentos en variables
directorio=$1
ext_entrada=$2
ext_salida=$3

# Verifico que el directorio existe
if [ ! -d "$directorio" ]; then
    echo "Error: El directorio $directorio no existe"
    exit 1
fi

# Cambio al directorio especificado
cd "$directorio"


for archivo in *."$ext_entrada"; do
    if [ ! -f "$archivo" ]; then
        echo "No hay archivos con extensión .$ext_entrada"
        exit 1
    fi

    nombre_base=${archivo%.*}
    convert "$archivo" "$nombre_base.$ext_salida"
    
    if [ $? -eq 0 ]; then
        echo "Convertido: $archivo -> $nombre_base.$ext_salida"
    else
        echo "Error al convertir: $archivo"
    fi
done