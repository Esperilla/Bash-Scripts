#!/bin/bash

HASH="$1"
DIR="$2"
NUM_CPUS=$(nproc)
TMP_DIR=$(mktemp -d)

#División del diccionario entre los núcleos
split -n l/$NUM_CPUS "$DIR" "$TMP_DIR/dict_part_"

#Trabajador
worker() {
    local part=$1
    while IFS= read -r password; do
        #Comparación directa del hash generado con el hash original
        if [[ "$(mkpasswd -m yescrypt -S '$y$j9T$V3EgZSB8/t0K431bVP6dd/' "$password")" == "$HASH" ]]; then
            echo "[+] Contraseña encontrada: $password"
            kill 0
            exit 0
        fi
    done < "$part"
}

#Inicio de los trabajadores
for part in "$TMP_DIR"/dict_part_*; do
    worker "$part" &
done

sleep 40


<< 'EOF'
./cracker.sh '$y$j9T$V3EgZSB8/t0K431bVP6dd/$yObsjeTuIRSu7S8THMt1ylqlN3FcuaeEDAZaouqv4l5' listado-general.txt
mkpasswd -m yescrypt "palabra"

HASH original:  $y$j9T$V3EgZSB8/t0K431bVP6dd/ 	$yObsjeTuIRSu7S8THMt1ylqlN3FcuaeEDAZaouqv4l5  (remendado)
HASH prueba:    $y$j9T$Mgsfe.4.zMbjqCMVLXI2E0 	$.71b/O8DBLJiX/C7gOq7m6VIM2yhm4i00O5gzY/CkF6  (zuzo)
HASH original 2	$y$j9T$RDdyiMfRMRHVem7Af3a4W1	$gAZq5OA49IbAjudhmJRlPBubhJXyF/F0XIGnj8OUQM8  (remendado)
EOF