#!/bin/bash

# Función de ayuda
function mostrar_ayuda() {
    echo "Concatenar dos archivos en uno nuevo."
    echo ""
    echo "Uso: $0 <archivo1> <archivo2> <salida>"
    exit 0
}

test "$1" == "-h" || test "$1" == "--help" && { mostrar_ayuda; exit; }

if [ "$#" -ne 3 ]; then
    echo "Parametros insuficientes."
    mostrar_ayuda
    exit 1
fi

archivo1="$1"
archivo2="$2"
salida="$3"

# Verificar si los archivos de entrada existen
if [ ! -f "$archivo1" ]; then
    echo "Error: El archivo '$archivo1' no existe."
    exit 1
fi

if [ ! -f "$archivo2" ]; then
    echo "Error: El archivo '$archivo2' no existe."
    exit 1
fi

# Concatenar los archivos
cat "$archivo1" > "$salida"
cat "$archivo2" >> "$salida"

# Mensaje de éxito
echo "Archivos concatenados exitosamente en '$salida'."