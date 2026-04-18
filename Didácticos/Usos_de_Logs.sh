#!/bin/bash

# Script de servicio para suspensión automática por bajo uso de CPU
# Parámetros:
#   porcentaje_minimo_cpu: Umbral mínimo de CPU (ej: 10 para 10%)
#   tiempo_segundos: Tiempo en segundos de bajo uso antes de suspender
# Señales:
#   USR1: Desactiva la suspensión automática
#   USR2: Reactiva la suspensión automática

# Verificar parámetros
if [ $# -ne 2 ]; then
    echo "Uso: $0 <porcentaje_minimo_cpu> <tiempo_segundos>"
    echo "Ejemplo: $0 10 60"
    exit 1
fi

# Parámetros del script
UMBRAL_CPU=$1
TIEMPO_LIMITE=$2

# Variables de control
SUSPENSION_ACTIVA=1
CONTADOR_TIEMPO=0
PID=$$

# Archivo de log para debug
LOG_FILE="/tmp/suspenServicio.log"

# Función para logging
log_mensaje() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [PID: $PID] $1" >> "$LOG_FILE"
}

# Función para manejar señal USR1 (desactivar suspensión)
manejar_usr1() {
    SUSPENSION_ACTIVA=0
    CONTADOR_TIEMPO=0
    log_mensaje "SEÑAL USR1 recibida - Suspensión DESACTIVADA"
    echo "Suspensión automática DESACTIVADA"
}

# Función para manejar señal USR2 (reactivar suspensión)
manejar_usr2() {
    SUSPENSION_ACTIVA=1
    CONTADOR_TIEMPO=0
    log_mensaje "SEÑAL USR2 recibida - Suspensión REACTIVADA"
    echo "Suspensión automática REACTIVADA"
}

# Función para manejar señal TERM/INT (terminar script limpiamente)
manejar_terminar() {
    log_mensaje "Señal de terminación recibida - Finalizando servicio"
    echo "Terminando servicio de suspensión..."
    exit 0
}

# Función para obtener el uso de CPU
obtener_uso_cpu() {
    # Extraer el porcentaje de CPU usado del comando top
    local cpu_info=$(top -n 1 -b | grep '%Cpu')
    
    # Extraer el porcentaje de CPU usado (us = user space)
    # Formato típico: %Cpu(s):  2.0 us,  1.0 sy,  0.0 ni, 97.0 id, ...
    local cpu_usado=$(echo "$cpu_info" | awk '{print $2}' | sed 's/us,//')
    
    # Convertir a entero (eliminar decimales)
    cpu_usado=$(echo "$cpu_usado" | cut -d'.' -f1)
    
    # Si no se pudo obtener, retornar 100 (evitar suspensión por error)
    if [[ ! "$cpu_usado" =~ ^[0-9]+$ ]]; then
        cpu_usado=100
    fi
    
    echo "$cpu_usado"
}

# Función para suspender el sistema
suspender_sistema() {
    log_mensaje "SUSPENDIENDO SISTEMA - CPU bajo ($1%) durante $TIEMPO_LIMITE segundos"
    echo "=== SUSPENDIENDO SISTEMA ==="
    echo "CPU estuvo por debajo de $UMBRAL_CPU% durante $TIEMPO_LIMITE segundos"
    echo "Último uso de CPU: $1%"
    
    # Simular suspensión (en producción sería: systemctl suspend)
    echo "systemctl suspend (SIMULADO)"
    
    # Reiniciar contador después de la suspensión simulada
    CONTADOR_TIEMPO=0
}

# Configurar manejadores de señales
trap manejar_usr1 USR1
trap manejar_usr2 USR2
trap manejar_terminar TERM INT

# Inicializar
log_mensaje "Iniciando servicio de suspensión - Umbral: $UMBRAL_CPU%, Tiempo: $TIEMPO_LIMITE seg"
echo "Servicio de suspensión iniciado (PID: $PID)"
echo "Umbral CPU: $UMBRAL_CPU%"
echo "Tiempo límite: $TIEMPO_LIMITE segundos"
echo "Enviar SIGUSR1 para desactivar, SIGUSR2 para reactivar"
echo "Para terminar: kill $PID"

# Bucle principal del servicio
while true; do
    # Obtener uso actual de CPU
    uso_cpu_actual=$(obtener_uso_cpu)
    
    # Verificar si la suspensión está activa
    if [ $SUSPENSION_ACTIVA -eq 1 ]; then
        # Verificar si el uso de CPU está por debajo del umbral
        if [ $uso_cpu_actual -lt $UMBRAL_CPU ]; then
            CONTADOR_TIEMPO=$((CONTADOR_TIEMPO + 1))
            echo "CPU bajo: $uso_cpu_actual% (${CONTADOR_TIEMPO}/${TIEMPO_LIMITE}s)"
            
            # Si se alcanzó el tiempo límite, suspender
            if [ $CONTADOR_TIEMPO -ge $TIEMPO_LIMITE ]; then
                suspender_sistema $uso_cpu_actual
            fi
        else
            # CPU por encima del umbral, reiniciar contador
            if [ $CONTADOR_TIEMPO -gt 0 ]; then
                echo "CPU normal: $uso_cpu_actual% - Reiniciando contador"
                CONTADOR_TIEMPO=0
            fi
        fi
    else
        # Suspensión desactivada
        if [ $(($(date +%s) % 10)) -eq 0 ]; then  # Mostrar cada 10 segundos
            echo "Suspensión DESACTIVADA - CPU actual: $uso_cpu_actual%"
        fi
    fi
    
    # Esperar 1 segundo antes de la siguiente muestra
    sleep 1
done