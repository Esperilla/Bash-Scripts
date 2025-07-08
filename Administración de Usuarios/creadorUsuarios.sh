#!/bin/bash

mostrar_ayuda(){
    echo "Creador de Usuarios"
    echo "Este script crea un nuevo usuario en el sistema con una contraseña aleatoria."
    echo ""
    echo "Uso: $0 "
}

test "$1" == "-h" || test "$1" == "--help" && { mostrar_ayuda; exit; }

# Verificar si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

# Solicitar el nombre de usuario
echo -n "Ingrese el nombre de usuario: "
read USERNAME

# Verificar si el usuario ya existe
if id "$USERNAME" &>/dev/null; then
    echo "El usuario '$USERNAME' ya existe."
    exit 1
fi

# Crear el usuario
useradd -m -s /bin/bash "$USERNAME"
if [[ $? -ne 0 ]]; then
    echo "Error al crear el usuario."
    exit 1
fi

# Generar una contraseña aleatoria
PASSWORD=$(openssl rand -base64 12)
echo "$USERNAME:$PASSWORD" | chpasswd

# Mostrar la información de la cuenta
echo "Usuario creado exitosamente."
echo "Nombre de usuario: $USERNAME"
echo "Contraseña: $PASSWORD"

echo "Es recomendable cambiar la contraseña en el primer inicio de sesión."
passwd -e "$USERNAME"

exit 0