#!/bin/bash

# Verificar si se recibieron los argumentos necesarios
if [ $# -ne 2 ]; then
    echo "Uso: $0 directorio queue_name"
    exit 1
fi

directory="$1"
queue_name="$2"

# Contar archivos regulares en el directorio
count=$(find "$directory" -type f -print | wc -l)

# Enviar el resultado a través de la cola de mensajes POSIX
echo "$count" > /dev/mqueue$queue_name