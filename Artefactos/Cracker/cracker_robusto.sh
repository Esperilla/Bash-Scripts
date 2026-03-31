#!/bin/bash
set -u

# Cracker por diccionario en paralelo para hashes yescrypt.
# Uso: ./cracker_robusto.sh '<hash_yescrypt>' <archivo_diccionario>

usage() {
    echo "Uso: $0 '<hash_yescrypt>' <archivo_diccionario>" >&2
    exit 1
}

if [[ $# -ne 2 ]]; then
    usage
fi

HASH="$1"
DICT_FILE="$2"

if [[ ! -r "$DICT_FILE" ]]; then
    echo "[!] No se puede leer el diccionario: $DICT_FILE" >&2
    exit 1
fi

if ! [[ "$HASH" =~ ^\$y\$[^$]+\$[^$]+\$[^$]+$ ]]; then
    echo "[!] El hash no parece yescrypt valido." >&2
    exit 1
fi

for cmd in split mktemp nproc; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[!] Falta el comando requerido: $cmd" >&2
        exit 1
    fi
done

TMP_DIR="$(mktemp -d)"
FOUND_FILE="$TMP_DIR/found.txt"
PART_PREFIX="$TMP_DIR/dict_part_"

PIDS=()

cleanup() {
    local pid
    for pid in "${PIDS[@]:-}"; do
        if kill -0 "$pid" >/dev/null 2>&1; then
            kill "$pid" >/dev/null 2>&1 || true
        fi
    done

    if [[ -d "$TMP_DIR" ]]; then
        rm -rf "$TMP_DIR"
    fi
}
trap cleanup EXIT INT TERM

# Verificacion robusta usando crypt(3) con el hash completo como "setting".
# Esto respeta parametros y sal del hash objetivo.
verify_password() {
    local candidate="$1"

    if command -v python3 >/dev/null 2>&1; then
        python3 - "$candidate" "$HASH" <<'PY' >/dev/null 2>&1
import sys
import crypt
candidate = sys.argv[1]
target = sys.argv[2]
calc = crypt.crypt(candidate, target)
sys.exit(0 if calc == target else 1)
PY
        return $?
    fi

    if command -v python >/dev/null 2>&1; then
        python - "$candidate" "$HASH" <<'PY' >/dev/null 2>&1
import sys
import crypt
candidate = sys.argv[1]
target = sys.argv[2]
calc = crypt.crypt(candidate, target)
sys.exit(0 if calc == target else 1)
PY
        return $?
    fi

    if command -v perl >/dev/null 2>&1; then
        perl -e 'exit((crypt($ARGV[0],$ARGV[1]) eq $ARGV[1]) ? 0 : 1)' "$candidate" "$HASH" >/dev/null 2>&1
        return $?
    fi

    echo "[!] No hay verificador disponible (python3/python/perl)." >&2
    return 2
}

worker() {
    local part="$1"
    local password

    while IFS= read -r password; do
        # Si otro proceso ya encontro la clave, cortar temprano.
        [[ -s "$FOUND_FILE" ]] && return 0

        if verify_password "$password"; then
            printf '%s\n' "$password" > "$FOUND_FILE"
            return 0
        fi
    done < "$part"
}

NUM_CPUS="$(nproc 2>/dev/null || echo 1)"
if ! [[ "$NUM_CPUS" =~ ^[0-9]+$ ]] || [[ "$NUM_CPUS" -lt 1 ]]; then
    NUM_CPUS=1
fi

# Divide el diccionario entre nucleos logicos.
split -n "l/$NUM_CPUS" "$DICT_FILE" "$PART_PREFIX"

shopt -s nullglob
parts=("$PART_PREFIX"*)
shopt -u nullglob

if [[ ${#parts[@]} -eq 0 ]]; then
    echo "[!] No se pudieron crear fragmentos del diccionario." >&2
    exit 1
fi

for part in "${parts[@]}"; do
    worker "$part" &
    PIDS+=("$!")
done

# Espera a que terminen todos o a que aparezca la clave.
for pid in "${PIDS[@]}"; do
    wait "$pid" || true
    if [[ -s "$FOUND_FILE" ]]; then
        break
    fi
done

if [[ -s "$FOUND_FILE" ]]; then
    FOUND_PASSWORD="$(head -n 1 "$FOUND_FILE")"
    echo "[+] Contraseña encontrada: $FOUND_PASSWORD"
    exit 0
fi

echo "[-] No se encontro la contraseña en el diccionario."
exit 2
