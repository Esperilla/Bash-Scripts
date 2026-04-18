#!/bin/bash

# Script que crea un archivo con la fecha actual como nombre dentro de
# la ruta recibida como parametro y escribe un texto inicial.

ruta="$1"
fecha="$(date +%Y-%m-%d)"
echo "hola mundo" > "$ruta/$fecha"