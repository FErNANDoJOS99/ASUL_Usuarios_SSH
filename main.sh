#!/bin/bash

# Asegúrate de que todos los scripts sean ejecutables
chmod +x limpiarScript.sh agregarDNS.sh crearUsuarios.sh limpiarRSA.sh agregarLlavePub.sh


bash limpiarScript.sh 
bash agregarDNS.sh
bash limpiarRSA.sh
bash crearUsuarios.sh
bash agregarLlavePub.sh


