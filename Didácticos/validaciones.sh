#!/bin/bash

# Script que valida que se reciba un archivo y un directorio, luego
# verifica si el archivo contiene la cadena 'hola' y crea un indicador.

# Validación de parámetros
if [ $# -lt 2 ]; then
    echo "¡ERROR!: Se requieren dos parámetros"
    echo "<archivo> <directorio>"
    exit 1
fi

# Validación del primer parámetro (archivo)
if [ ! -f "$1" ]; then
    echo "¡ERROR!: El primer parámetro debe ser un archivo"
    exit 1
fi

# Validación del segundo parámetro (directorio)
if [ ! -d "$2" ]; then
    echo "¡ERROR!: El segundo parámetro debe ser un directorio"
    exit 1
fi

# Asignación de parámetros
archivo="$1"
directorio="$2"

# Verificación de la cadena
if grep -q 'hola' "$archivo"; then
    touch "$directorio/contiene.txt"
    echo "El archivo contiene la cadena 'hola'"
else
    touch "$directorio/NoContiene.txt"
    echo "El archivo no contiene la cadena 'hola'"
fi