#!/bin/bash

mostrar_ayuda() {
    echo "Uso: $0 <directorio> \"<cadena de búsqueda>\""
    echo "Busca archivos en un directorio que contengan todas las palabras de la cadena de búsqueda en su nombre."
    exit 1
}

test "$1" == "-h" || test "$1" == "--help" && { mostrar_ayuda; exit; }

#Valido que se reciban dos parámetros:
if [ "$#" -ne 2 ]; then
    echo "Error: Se necesitan dos parámetros: un directorio y una cadena de búsqueda."
    mostrar_ayuda
    exit 1
fi

directorio="$1"
cadena="$2"

#Valido que el primer parámetro sea un directorio:
if [ ! -d "$directorio" ]; then
    echo "Error: $directorio no es un directorio válido."
    exit 1
fi

#Convierto la cadena en un arreglo de palabras:
IFS=' ' read -r -a palabras <<< "$cadena"

#Lista de archivos
archivos_encontrados=()

#Recorro el directorio
for archivo in "$directorio"/*; do
    if [ -f "$archivo" ]; then
        nombre_archivo="$(basename "$archivo")"
        for palabra in "${palabras[@]}"; do
            if echo "$nombre_archivo" | grep -qw "$palabra"; then
                archivos_encontrados+=("$nombre_archivo")
                break
            fi
        done
    fi
done

#Muestro los archivos encontrados
if [ "${#archivos_encontrados[@]}" -eq 0 ]; then
    echo "No se encontraron archivos que coincidan con la búsqueda."
else
    echo "Archivos encontrados:"
    printf "%s\n" "${archivos_encontrados[@]}"
fi