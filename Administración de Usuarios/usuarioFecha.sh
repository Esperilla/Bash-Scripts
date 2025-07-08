#!/bin/bash

mostrar_ayuda(){
    echo "Script de Copia de Archivos"
    echo "Este script copia un archivo a un directorio de destino y agrega la fecha al nombre del archivo."
    echo ""
    echo "Uso: $0 <archivo_origen> <directorio_destino>"
    
}

test "$1" == "-h" || test "$1" == "--help" && { mostrar_ayuda; exit; }

archivoOrigen="$1"
directorioDestino="$2"

#Nombre del archivo
nombreArchivo=$(basename "$archivoOrigen$(date +%y-%m-%d)")

#Ruta completa de destino
rutaDestino="$directorioDestino/$nombreArchivo"

#Copiar el archivo
cp "$archivoOrigen" "$rutaDestino"
whoami > $rutaDestino
cat $archivoOrigen >> $rutaDestino