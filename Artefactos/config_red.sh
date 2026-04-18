#!/bin/bash

# Script que lee un archivo con datos de red y configura una IP
# estatica por interfaz usando ifconfig.

# Verificar si se recibió un archivo como argumento
if [ "$#" -ne 1 ]; then
  echo "Uso: $0 archivo.txt"
  exit 1
fi

# Leer el archivo línea por línea
while IFS=, read -r interfaz ip mascara; do
  # Configurar la IP estática para la interfaz
  echo "Configurando $interfaz con IP $ip y Máscara $mascara"
  sudo ifconfig $interfaz $ip netmask $mascara up
done < "$1"