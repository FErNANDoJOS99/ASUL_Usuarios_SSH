#!/bin/bash

# El objetivo de este script es acomodar en columnas la informacion aunque los nombres de usuario no 
# sean recuperables.


archivo="archivooriginal.csv"
#poner
#archivo="salida.csv"


# poner2
#archivo="archivooriginal.csv"


# archivo="$1"

# # Verifica que se pasó un archivo válido
# if [ ! -f "$archivo" ]; then
#     echo "❌ Archivo no encontrado: $archivo"
#     exit 1
# fi




# Poner
archivo_salida="archivo_limpio.csv"

# Agregar la primera línea (cabecera) sin cambios
#head -n 1 "$archivo" > "$archivo_salida"

# Leer el resto del contenido ignorando líneas vacías
contenido=$(tail -n +1 "$archivo" | grep -v '^[[:space:]]*$')

# Unir todo en una sola línea (sin saltos de línea)
contenido_unido=$(echo "$contenido" | tr -d '\n')

# Procesar fechas y agregar saltos de línea antes de cada una
#poner
echo "$contenido_unido" | \
awk '{gsub(/[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}/, "\n&"); print}' \
> archivo_salida2.csv






# Agregar el contenido procesado al archivo final
#cat archivo_salida2.csv >> "$archivo_salida"
#Poner
cat archivo_salida2.csv > "$archivo_salida"



# Opcional: eliminar retorno de carro (\r) si viene de Windows
# sed -i 's/\r$//' "$archivo_salida"

