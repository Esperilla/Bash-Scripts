#!/bin/bash

mostrar_ayuda() {
    echo "Uso: $0 -c|-m archivo_entrada directorio_salida"
    echo "Descripción: Copia o mueve un archivo a un directorio de salida"
    echo "Opciones:"
    echo "  -c    Copiar el archivo"
    echo "  -m    Mover el archivo"
    echo "  -h    Mostrar esta mostrar_ayuda"
}

test "$1" == "-h" || test "$1" == "--help" && { mostrar_ayuda; exit; }

#Inicializo las variables
opcion_copiar=""
opcion_mover=""
accion=""

#Opciones
while getopts ":cmh" opt; do
    case $opt in
        c)
            opcion_copiar="1"
            accion="cp"
            ;;
        m)
            opcion_mover="1"
            accion="mv"
            ;;
        h)
            mostrar_ayuda
            exit 0
            ;;
        \?)
            echo "Error: Opción inválida -$OPTARG"
            mostrar_ayuda
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

#Valido que solo se use una opción
if [[ -n "$opcion_copiar" && -n "$opcion_mover" ]]; then
    echo "ERROR: No se pueden usar las opciones -c y -m al mismo tiempo"
    mostrar_ayuda
    exit 1
fi

#Valido que se haya especificado una opción
if [[ -z "$accion" ]]; then
    echo "ERROR: Especifíca -c para copiar o -m para mover"
    mostrar_ayuda
    exit 1
fi

#Valido el número de argumentos
if [[ $# -ne 2 ]]; then
    echo "ERROR: Se necesita un archivo de entrada y directorio de salida"
    mostrar_ayuda
    exit 1
fi

archivoEntrada="$1"
directorioSalida="$2"

#Valido que el archivo de entrada exista
if [[ ! -f "$archivoEntrada" ]]; then
    echo "ERROR: El archivo de entrada '$archivoEntrada' no existe"
    exit 1
fi

#Valido que el directorio de salida exista
if [[ ! -d "$directorioSalida" ]]; then
    echo "ERROR: El directorio de salida '$directorioSalida' no existe"
    exit 1
fi

#Ejecución
$accion "$archivoEntrada" "$directorioSalida"