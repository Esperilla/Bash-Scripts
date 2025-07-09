#!/bin/bash

# Script para comprimir recursivamente archivos y directorios en formato .zip

# Colores para salidas
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Ayuda
mostrar_ayuda() {
    echo -e "${BLUE}=== COMPRESOR RECURSIVO ZIP ===${NC}"
    echo ""
    echo "Uso: $0 [OPCIONES] <directorio_origen> [archivo_destino.zip]"
    echo ""
    echo "Opciones:"
    echo "  -h, --help              Mostrar esta ayuda"
    echo "  -v, --verbose           Modo verbose (mostrar archivos procesados)"
    echo "  -p, --password          Proteger con contraseña"
    echo ""
    echo "Ejemplos:"
    echo "  $0 /home/usuario/documentos"
    echo "  $0 /home/usuario/documentos mi_backup.zip"
    echo "  $0 -v -c 9 /home/usuario/documentos backup_completo.zip"
    echo ""
}

# Verificar dependencias
verificar_dependencias() {
    if ! command -v zip &> /dev/null; then
        echo -e "${RED}Error: El comando 'zip' no está instalado.${NC}"
        echo "Para instalar en Ubuntu/Debian: sudo apt-get install zip"
        echo "Para instalar en CentOS/RHEL: sudo yum install zip"
        exit 1
    fi
}

# Función para comprimir
comprimir_directorio() {
    local directorio="$1"
    local archivo_zip="$2"
    
    # Validar que el directorio existe
    if [[ ! -d "$directorio" ]]; then
        echo -e "${RED}Error: El directorio '$directorio' no existe.${NC}"
        exit 1
    fi
    
    # Construir comando zip
    local cmd_zip="zip"
    
    # Agregar modo recursivo
    cmd_zip="$cmd_zip -r"
    
    # Agregar modo verbose si está activado
    if [[ "$VERBOSE" == "true" ]]; then
        cmd_zip="$cmd_zip -v"
    fi
    
    # Agregar contraseña si está especificada
    if [[ "$USAR_PASSWORD" == "true" ]]; then
        cmd_zip="$cmd_zip -P $PASSWORD"
    fi
    
    # Agregar archivo destino y directorio origen
    cmd_zip="$cmd_zip \"$archivo_zip\" \"$directorio\""
    
    echo -e "${BLUE}Iniciando compresión...${NC}"
    echo -e "${YELLOW}Directorio origen: $directorio${NC}"
    echo -e "${YELLOW}Archivo destino: $archivo_zip${NC}"

    echo ""
    
    # Ejecutar comando
    eval "$cmd_zip"
    
    # Verificar resultado
    if [[ $? -eq 0 ]]; then
        echo ""
        echo -e "${GREEN}✓ Compresión completada exitosamente!${NC}"
        
        # Mostrar información del archivo creado
        if [[ -f "$archivo_zip" ]]; then
            local tamano=$(du -h "$archivo_zip" 2>/dev/null | awk '{print $1}' || stat -c%s "$archivo_zip" 2>/dev/null | numfmt --to=iec || echo "N/A")
            echo -e "${GREEN}Archivo creado: $archivo_zip ($tamano)${NC}"
        fi
    else
        echo ""
        echo -e "${RED}✗ Error durante la compresión.${NC}"
        exit 1
    fi
}

# Función para solicitar contraseña
solicitar_password() {
    echo -n "Ingrese la contraseña para el archivo ZIP: "
    read -s PASSWORD
    echo ""
    
    if [[ -z "$PASSWORD" ]]; then
        echo -e "${RED}Error: La contraseña no puede estar vacía.${NC}"
        exit 1
    fi
}

# Variables por defecto
VERBOSE="false"
USAR_PASSWORD="false"
PASSWORD=""

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            mostrar_ayuda
            exit 0
            ;;
        -v|--verbose)
            VERBOSE="true"
            shift
            ;;
        -p|--password)
            USAR_PASSWORD="true"
            shift
            ;;
        -*)
            echo -e "${RED}Error: Opción desconocida: $1${NC}"
            mostrar_ayuda
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# Verificar argumentos mínimos
if [[ $# -lt 1 ]]; then
    echo -e "${RED}Error: Debe especificar al menos el directorio a comprimir.${NC}"
    echo ""
    mostrar_ayuda
    exit 1
fi

# Verificar dependencias
verificar_dependencias

# Obtener directorio origen
DIRECTORIO_ORIGEN="$1"

# Obtener archivo destino (si no se especifica, usar nombre del directorio)
if [[ -n "$2" ]]; then
    ARCHIVO_DESTINO="$2"
else
    NOMBRE_BASE=$(basename "$DIRECTORIO_ORIGEN")
    ARCHIVO_DESTINO="${NOMBRE_BASE}_$(date +%Y%m%d_%H%M%S).zip"
fi

# Asegurar extensión .zip
if [[ ! "$ARCHIVO_DESTINO" =~ \.zip$ ]]; then
    ARCHIVO_DESTINO="${ARCHIVO_DESTINO}.zip"
fi

# Solicitar contraseña si está activada la opción
if [[ "$USAR_PASSWORD" == "true" ]]; then
    solicitar_password
fi

# Verificar si el archivo destino ya existe
if [[ -f "$ARCHIVO_DESTINO" ]]; then
    echo -e "${YELLOW}Advertencia: El archivo '$ARCHIVO_DESTINO' ya existe.${NC}"
    echo -n "¿Desea sobrescribirlo? (s/N): "
    read -r respuesta
    if [[ ! "$respuesta" =~ ^[sS]$ ]]; then
        echo "Operación cancelada."
        exit 0
    fi
fi

# Ejecutar compresión
comprimir_directorio "$DIRECTORIO_ORIGEN" "$ARCHIVO_DESTINO"

echo ""
echo -e "${GREEN}¡Proceso completado!${NC}"