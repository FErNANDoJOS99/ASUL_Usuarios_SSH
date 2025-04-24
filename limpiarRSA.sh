#!/bin/bash


# Objetivo de este script es quitar todos los RSA y enfocarse en los nombres de usuarios

archivo="archivooriginal.csv"
salida="salida.csv"

# Verifica que se pasó un archivo válido
# if [ ! -f "$archivo" ]; then
#     echo "❌ Archivo no encontrado: $archivo"
#     exit 1
# fi



# Eliminar desde "ssh-rsa hasta la siguiente comilla doble , eleminamos los espacios en blanco  , cambiamos los
# saltos de linea (\n) si le precede una comilla y ponemos una coma



### ahora si hacerlo completo sin quitar comilla 
sed -zE 's/,[[:space:]]*"ssh[^"]*"/\n/g' "$archivo" | grep -v '^[[:space:]]*$' | perl -0777 -pe 's/(?<!")\n/,/g' > "$salida"


# ##Lo mismo que arriba pero quita comillas dobles 
# sed -zE 's/,[[:space:]]*"ssh[^"]*"/\n/g' "$archivo" \
# | grep -v '^[[:space:]]*$' \
# | perl -0777 -pe 's/(?<!")\n/,/g' \
# | tr -d '"' > "$salida"





#Funciona para quitar todos los espacios
#grep -v '^[[:space:]]*$' "$archivo" > "$salida"


echo "✅ Eliminación con salto de línea completada. Archivo guardado como: $salida"
