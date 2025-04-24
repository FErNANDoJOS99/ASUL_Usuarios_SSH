#!/bin/bash

archivo="salida.csv"

# Verificación de archivo
if [[ ! -f "$archivo" ]]; then
  echo "Archivo no encontrado: $archivo"
  exit 1
fi

# Funciones
programa1() {
  echo "Soy programa 1: Columna 4 = $1, Columna 5 = $2"
}

programa2() {

  entrada="$1"
#   entrada="${entrada//\"/}"
#   entrada="${entrada//\'/}"



  # Separar por comas
  IFS=',' read -ra elementos <<< "$entrada"

  # Imprimir cada elemento con "2 " delante
  for elemento in "${elementos[@]}"; do
     # Quitar números, espacios y puntos
    limpio=$(echo "$elemento" | sed 's/[0-9.]//g')
    #Esta linea quita los inicios y los finales de los archivos
    limpio2=$(echo "$limpio" | sed 's/^[[:space:]]*//')


    #Verificar si el usuario ya existe
    if id "$limpio" &>/dev/null; then
      echo "⚠️  El usuario '$limpio2' ya existe."
    else
      sudo useradd "$limpio2" && echo "✅ Usuario '$limpio2' creado."
    fi
    echo "$limpio2"
   done 
}



programa3() {
  echo "Soy programa 3: Columna 8 = $1"
}

# Exportar funciones como texto
programa1_def=$(declare -f programa1)
programa2_def=$(declare -f programa2)
programa3_def=$(declare -f programa3)

# Procesar CSV
tail -n +2 "$archivo" | awk -v FPAT='([^,]*)|(\"[^\"]*\")' \
-v p1="$programa1_def" -v p2="$programa2_def" -v p3="$programa3_def" '
{
  gsub(/"/, "", $4); gsub(/"/, "", $5);
  gsub(/"/, "", $7); gsub(/"/, "", $8);

  cmd1 = "bash -c '\''" p1 " ; programa1 \"" $4 "\" \"" $5 "\"'\''"
  system(cmd1)

  cmd2 = "bash -c '\''" p2 " ; programa2 \"" $7 "\"'\''"
  system(cmd2)

  cmd3 = "bash -c '\''" p3 " ; programa3 \"" $8 "\"'\''"
  system(cmd3)

  print "----"
}
'
