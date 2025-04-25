#!/bin/bash

archivo="archivo_limpio.csv"


# Verifica si el archivo existe
if [[ ! -f "$archivo" ]]; then
  echo "El archivo '$archivo' no existe."
  exit 1
fi



procesar_usuario() {
    usuario="$1"
    clave="$2"

    # Verificar si el nombre de usuario está contenido en la cadena de clave
    if [[ "$clave" == *"$usuario"* ]]; then
        # Verificar si el directorio .ssh existe en el home del usuario
        home_usuario=$(eval echo ~$usuario)
        ssh_dir="$home_usuario/.ssh"

        if [[ ! -d "$ssh_dir" ]]; then
            # Si no existe, creamos el directorio .ssh
            mkdir -p "$ssh_dir"
            chmod 700 "$ssh_dir"
            echo "Directorio .ssh creado en $home_usuario"
        fi

        # Asegurarse de que el archivo authorized_keys exista
        authorized_keys="$ssh_dir/authorized_keys"
        if [[ ! -f "$authorized_keys" ]]; then
            touch "$authorized_keys"
            chmod 600 "$authorized_keys"
            echo "Archivo authorized_keys creado en $ssh_dir"
        fi

        # Añadir la clave al archivo authorized_keys si no está ya presente
        if ! grep -q "$clave" "$authorized_keys"; then
            echo "$clave" >> "$authorized_keys"
            echo "Clave añadida a $usuario en $authorized_keys"
        else
            echo "La clave ya existe en $usuario"
        fi
    else
        echo "El parámetro 1 (usuario) no está contenido en el parámetro 2 (clave)."
    fi
}



procesar_fragmento() {
    fragmento="$1"
    #echo "🔹 Procesando fragmento: $fragmento"

    # Obtener usuarios reales (UID >= 1000 en la mayoría de sistemas Linux)
    usuarios=($(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd))

    # Parámetro adicional que quieras pasar
    info_extra=$fragmento

    # Recorrer usuarios y pasarlos a la función
    for user in "${usuarios[@]}"; do
        procesar_usuario "$user" "$info_extra"
    done



}


procesar_fila() {
    cadena="$1"

    # Usamos un marcador temporal poco común
    modificado="${cadena//ssh-/§§§ssh-}"

    # Quitamos marcador inicial si aparece al principio
    modificado="${modificado#§§§}"

    # Convertimos en array usando salto de línea
    IFS=$'\n' read -d '' -ra partes <<< "${modificado//$'§§§'/$'\n'}"

    for parte in "${partes[@]}"; do
        [[ -n "$parte" ]] && procesar_fragmento "$parte"
    done
}

# Usar awk para extraer campos y llamar funciones bash
awk -v FPAT='([^,]+)|(\"[^\"]+\")' '
NR > 1 {
    for (i = 1; i <= NF; i++) {
        gsub(/^"|"$/, "", $i)
    }
    print $7 "|" $2 "|" $3
}' "$archivo" | while IFS="|" read -r nombre edad ciudad; do
    procesar_fila "$nombre"
done