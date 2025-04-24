#!/bin/bash
#set -x



#archivo=$(bash limpiarScript.sh archivooriginal.csv)


archivo="archivo_limpio.csv"

# Verificación de archivo
if [[ ! -f "$archivo" ]]; then
  echo "Archivo no encontrado: $archivo"
  exit 1
fi

# Funciones

## Agrega el DNS Local 
programa1() {
  echo "Soy programa 1: Columna 4 = $1, Columna 5 = $2"
  #agregar_dns_local() {
  local dominio="$1"
  #local ip="${2:-127.0.0.1}"
  local ip="$2"

  if [[ -z "$dominio" ]]; then
    echo "Uso: agregar_dns_local nombre.dominio [ip]"
    return 1
  fi

  # Verificar si el dominio ya está en /etc/hosts
  if grep -qw "$dominio" /etc/hosts; then
    echo "⚠️  El dominio '$dominio' ya existe en /etc/hosts"
  else
    echo "$ip $dominio" | sudo tee -a /etc/hosts > /dev/null
    echo "✅ Dominio '$dominio' agregado apuntando a $ip"
  fi
}






programa2() {
  echo "Soy programa 2: Columna 7 = $1"
}

programa3() {
  echo "Soy programa 3: Columna 8 = $1"
}

# Exportar funciones como texto
programa1_def=$(declare -f programa1)
programa2_def=$(declare -f programa2)
programa3_def=$(declare -f programa3)

#echo "Contenido del archivo de entrada:"
#cat "$archivo"
#hexdump -C "$archivo"


# Procesar CSV
tail -n +2 "$archivo" | awk -v FPAT='([^,]*)|(\"[^\"]*\")' \
-v p1="$programa1_def" -v p2="$programa2_def" -v p3="$programa3_def" '
{
  gsub(/"/, "", $4); gsub(/"/, "", $5);
  gsub(/"/, "", $7); gsub(/"/, "", $8);

  cmd = "bash -c '\''" p1 " ; programa1 \"" $4 "\" \"" $5 "\"'\''"
  system(cmd)

  cmd = "bash -c '\''" p2 " ; programa2 \"" $7 "\"'\''"
  system(cmd)

  cmd = "bash -c '\''" p3 " ; programa3 \"" $8 "\"'\''"
  system(cmd)

  print "----"
}
'




# Función que agrega una entrada a /etc/hosts
# Aquí se llama la función con los parámetros del script
# $1 = nombre del dominio, $2 (opcional) = IP
#agregar_dns_local "$1" "$2"
