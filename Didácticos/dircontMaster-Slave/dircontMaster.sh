#!/bin/bash

# Verificar si se proporcionaron argumentos
if [ $# -eq 0 ]; then
    echo "Uso: $0 directorio1 [directorio2 ...]"
    exit 1
fi

# Nombre de la cola de mensajes
QUEUE_NAME="/dircount_queue"

# Crear cola de mensajes POSIX
if [ -e /dev/mqueue$QUEUE_NAME ]; then
    rm /dev/mqueue$QUEUE_NAME
fi

# Función para limpiar recursos al salir
cleanup() {
    rm -f /dev/mqueue$QUEUE_NAME
}

# Registrar función de limpieza
trap cleanup EXIT

# Total de archivos
total=0

# Por cada directorio, lanzar un proceso hijo
for dir in "$@"; do
    if [ ! -d "$dir" ]; then
        echo "Error: '$dir' no es un directorio"
        continue
    fi
    
    # Lanzar proceso hijo (slave) para contar archivos
    ./slave.sh "$dir" "$QUEUE_NAME" &
done

# Esperar a que terminen todos los procesos hijo
wait

# Leer resultados de la cola de mensajes
while read -r count < /dev/mqueue$QUEUE_NAME 2>/dev/null; do
    if [[ $count =~ ^[0-9]+$ ]]; then
        total=$((total + count))
    fi
done

echo "Total de archivos regulares en todos los directorios: $total"

# Este script tiene como objetivo principal mostrar cómo coordinar procesos en Bash (maestro y esclavo) para repartir 
# trabajo y consolidar resultados de manera eficiente y ordenada.