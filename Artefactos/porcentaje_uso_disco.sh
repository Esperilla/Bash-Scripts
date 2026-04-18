#!/bin/bash

# Script que obtiene el porcentaje de uso de disco de un punto de
# montaje usando la  salida del comando df -h.

# Función para mostrar ayuda
mostrar_ayuda() {
    echo "Uso: $0 <punto_de_montaje>"
    echo "Ejemplo: $0 /dev"
    echo "Ejemplo: $0 /"
    echo "Ejemplo: $0 /home"
    echo ""
    echo "Este script utiliza 'df -h' para obtener el porcentaje de uso de disco"
    echo "del punto de montaje especificado."
}

# Verificar que se proporcione un argumento
if [ $# -eq 0 ]; then
    echo "Error: No se proporcionó ningún punto de montaje"
    mostrar_ayuda
    exit 1
fi

# Verificar si se solicita ayuda
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    mostrar_ayuda
    exit 0
fi

PUNTO_MONTAJE="$1"

# Función principal para obtener el porcentaje de uso
obtener_porcentaje_uso() {
    local punto="$1"
    
    # Ejecutar df -h y buscar el punto de montaje específico
    # Usar grep con expresión regular para encontrar la línea exacta
    local linea_df=$(df -h | grep -E "^[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[0-9]+%[[:space:]]+${punto}$")
    
    # Si no se encuentra una coincidencia exacta, intentar buscar como substring
    if [ -z "$linea_df" ]; then
        linea_df=$(df -h | grep -E "[[:space:]]${punto}[[:space:]]*$")
    fi
    
    # Si aún no se encuentra, mostrar error
    if [ -z "$linea_df" ]; then
        echo "Error: No se encontró el punto de montaje '$punto'"
        echo "Puntos de montaje disponibles:"
        df -h | awk 'NR>1 {print $NF}' | sort
        return 1
    fi
    
    # Extraer el porcentaje usando expresión regular
    # El formato típico de df -h es: filesystem size used avail use% mounted_on
    # Usamos sed para extraer el campo que contiene el porcentaje
    local porcentaje=$(echo "$linea_df" | sed -E 's/^[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+([0-9]+%)[[:space:]]+.*$/\1/')
    
    # Verificar que se extrajo correctamente el porcentaje
    if [[ $porcentaje =~ ^[0-9]+%$ ]]; then
        echo "Punto de montaje: $punto"
        echo "Porcentaje de uso: $porcentaje"
        
        # Extraer solo el número sin el símbolo %
        local numero_porcentaje=$(echo "$porcentaje" | sed 's/%//')
        
        # Mostrar advertencia si el uso es alto
        if [ "$numero_porcentaje" -ge 90 ]; then
            echo "¡ADVERTENCIA! El uso de disco es crítico (≥90%)"
        elif [ "$numero_porcentaje" -ge 80 ]; then
            echo "¡ATENCIÓN! El uso de disco es alto (≥80%)"
        fi
        
        return 0
    else
        echo "Error: No se pudo extraer el porcentaje de uso"
        return 1
    fi
}

# Mostrar información del comando df -h para depuración (opcional)
echo "=== Información del sistema de archivos ==="
df -h | head -1  # Mostrar encabezados
echo ""

# Llamar a la función principal
obtener_porcentaje_uso "$PUNTO_MONTAJE"

# Capturar el código de salida
exit_code=$?

echo ""
echo "=== Salida completa de df -h para referencia ==="
df -h

exit $exit_code