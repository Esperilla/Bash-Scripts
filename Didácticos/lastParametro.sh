#!/bin/bash

# Script que recorre los argumentos recibidos y muestra el ultimo
# parametro proporcionado en la linea de comandos.

# Ayuda
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

# Variable para guardar el último parámetro
ultimo_parametro=""

# Recorro los parámetros
for parametro in "$@"; do
    ultimo_parametro="$parametro"
done

# Muestro el último parámetro
echo "$ultimo_parametro"