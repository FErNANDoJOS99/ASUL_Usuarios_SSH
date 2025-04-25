#!/bin/bash


#Este script crea usuarios con sus carpetas home correspondientes 

archivo="salida.csv"

# Verificación de archivo
if [[ ! -f "$archivo" ]]; then
  echo "Archivo no encontrado: $archivo"
  exit 1
fi

# Funciones


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
      sudo useradd -m -s /bin/bash "$limpio2" && sudo passwd -d "$limpio2" && echo "✅ Usuario '$limpio2' creado sin contraseña."
    fi
    echo "$limpio2"
   done 
}




# Exportar funciones como texto

programa2_def=$(declare -f programa2)


# Procesar CSV
tail -n +2 "$archivo" | awk -v FPAT='([^,]*)|(\"[^\"]*\")' \
-v p2="$programa2_def"  '
{
  gsub(/"/, "", $4); gsub(/"/, "", $5);
  gsub(/"/, "", $7); gsub(/"/, "", $8);


  cmd2 = "bash -c '\''" p2 " ; programa2 \"" $7 "\"'\''"
  system(cmd2)

  print "----"
}
'
