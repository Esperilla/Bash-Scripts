#!/bin/bash

mostrar_ayuda() {
    echo "Uso: $0 <directorio>"
    echo "Descripción: Elimina todos los archivos .txt de un directorio y sus subdirectorios de forma recursiva"
    exit 1
}

test "$1" == "-h" || test "$1" == "--help" && { mostrar_ayuda; exit; }

deleter_recursivo() {
    local ruta_dir="$1"
    
    #Verifico que exista el directorio
    if [ ! -d "$ruta_dir" ]; then
        echo "Error: El directorio $ruta_dir no existe"
        return 1
    fi

    #Borro los archivos .txt
    archivos_txt=("$ruta_dir"/*.txt)
    if [ -e "${archivos_txt[0]}" ]; then
        rm -f "$ruta_dir"/*.txt
        echo "Archivos .txt eliminados en: $ruta_dir"
    fi

    #Recorro recursivamente
    for subdir in "$ruta_dir"/*/; do
        if [ -d "$subdir" ]; then
            deleter_recursivo "$subdir"
        fi
    done
}

#Valido que se haya pasado un directorio como argumento 
if [ $# -ne 1 ]; then
    echo "Uso: $0 <directorio>"
    exit 1
fi

deleter_recursivo "$1"