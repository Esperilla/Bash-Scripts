#!/bin/bash

# Script que muestra un menu interactivo para actualizar repositorios,
# actualizar paquetes e instalar un paquete con apt.

update_repos() {
    sudo apt update
}

upgrade_paquetes() {
    sudo apt upgrade -y
}

install_paquete() {
    echo "paquete a instalar:"
    read nombrePaquete
    sudo apt install -y "$nombrePaquete"
}

OPTIONS="Actualizar_Repositorios Actualizar_Paquetes Instalar_Paquete Salir"
select opt in $OPTIONS; do
    case $opt in
        "Actualizar_Repositorios")
            update_repos
            ;;
        "Actualizar_Paquetes")
            upgrade_paquetes
            ;;
        "Instalar_Paquete")
            install_paquete
            ;;
        "Salir")
            echo "Saliendo..."
            exit
            ;;
        *)
            clear
            echo "Opción no válida"
            ;;
    esac
done