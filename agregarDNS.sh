#!/bin/bash
#set -x


#Este script crea las traducciones de nombre de maquina a las ip's correspondientes 


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








# Exportar funciones como texto
programa1_def=$(declare -f programa1)




# Procesar CSV
tail -n +2 "$archivo" | awk -v FPAT='([^,]*)|(\"[^\"]*\")' \
-v p1="$programa1_def"  '
{
  gsub(/"/, "", $4); gsub(/"/, "", $5);
  gsub(/"/, "", $7); gsub(/"/, "", $8);

  cmd = "bash -c '\''" p1 " ; programa1 \"" $4 "\" \"" $5 "\"'\''"
  system(cmd)


  print "----"
}
'


