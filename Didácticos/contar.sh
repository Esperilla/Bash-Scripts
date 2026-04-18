#!/bin/bash

# Script que cuenta cuantas veces aparece una cadena en uno o varios
# archivos y guarda los resultados en un archivo de salida.

ayuda() {
    echo "Uso: $0 -a cadena archivo1 [archivo2 ...] archivo_salida"
    echo "Descripción: "
    exit 1
}

# Valido parámetros
if [ $# -lt 4 ]; then
    ayuda
fi

# Procesar la opción -a y su parámetro
if [ "$1" != "-a" ]; then
    ayuda
fi
cadena="$2"
shift 2  # Eliminar -a y su parámetro de los argumentos

# El último argumento es el archivo de salida
archivo_salida="${@: -1}"
# Eliminar el último argumento (archivo de salida) del array
archivos=("${@:1:$#-1}")

# Validar que hay al menos un archivo para procesar
if [ ${#archivos[@]} -lt 1 ]; then
    echo "Error: Debe especificar al menos un archivo para procesar"
    ayuda
fi

# Validar que cada archivo existe y es un archivo regular
for archivo in "${archivos[@]}"; do
    if [ ! -f "$archivo" ]; then
        echo "Error: '$archivo' no existe o no es un archivo regular"
        exit 1
    fi
done

# Crear o limpiar el archivo de salida
> "$archivo_salida"

# Procesar cada archivo y contar las ocurrencias
for archivo in "${archivos[@]}"; do
    # Contar ocurrencias usando grep -c
    contador=$(grep -c "$cadena" "$archivo")
    # Escribir resultado al archivo de salida
    echo "$archivo:$contador" >> "$archivo_salida"
done