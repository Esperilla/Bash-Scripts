#!/bin/bash

# Script que calcula el n-esimo numero de Fibonacci usando recursividad
# y valida que el argumento recibido sea un entero positivo.

fibonacci() {
    local n=$1
    
    # Casos base
    if [ $n -eq 0 ]; then
        echo 0
        return
    elif [ $n -eq 1 ]; then
        echo 1
        return
    fi
    
    # Llamada recursiva
    local n1=$(fibonacci $((n-1)))
    local n2=$(fibonacci $((n-2)))
    echo $((n1 + n2))
}

# Valido que me den un argumento
if [ $# -ne 1 ]; then
    echo "Error: Debe proporcionar un número como argumento"
    exit 1
fi

# Valido que el argumento sea un número entero positivo
if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Error: El argumento debe ser un número entero positivo"
    exit 1
fi

# Calculo el resultado y lo muestro
resultado=$(fibonacci $1)
echo "Fibonacci($1) = $resultado"