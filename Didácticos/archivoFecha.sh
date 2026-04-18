#!/bin/bash

# Script que crea un archivo con la fecha actual en el nombre y 
# escribe un mensaje dentro.

nombre="creado$(date +%y-%m-%d).txt"
echo  "Archivo creado mediante el script archivoFecha.sh" >> $nombre 