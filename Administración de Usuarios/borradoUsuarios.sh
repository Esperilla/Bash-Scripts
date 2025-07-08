#!/bin/bash

mostrar_ayuda(){
    echo "Borrado de Usuarios"
    echo "Este script elimina un usuario del sistema."
    echo ""
    echo "Uso: $0 <nombre_de_usuario>"
    
}

test "$1" == "-h" || test "$1" == "--help" && { mostrar_ayuda; exit; }

# Verificar si se proporcionó un nombre de usuario
if [ $# -ne 1 ]; then
    mostrar_ayuda
    exit 1
fi

USER=$1

# Verificar si el usuario existe
if id "$USER" &>/dev/null; then
    echo "Eliminando usuario: $USER"
    
    # Eliminar el usuario y su directorio home
    userdel -r "$USER"
    
    if [ $? -eq 0 ]; then
        echo "Usuario $USER eliminado exitosamente."
    else
        echo "Error al eliminar el usuario $USER."
    fi
else
    echo "El usuario $USER no existe."
fi