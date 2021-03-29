#!/bin/bash

#Inicio do script

A=('0' '5' '10' '15' '20' '25' '30' '35' '40' '45' '50' '55' '60' '65' '70' '75' '80' '85' '90') # ângulos de emissão dos raios

mkdir resultados_esfera

for((i=0; i<19; i++)) do



  python  geometria_esfera.py ${A[i]}

  cp test_file.txt  resultados_ang${A[i]}

  cd resultados_esfera/

  mkdir resultados_ang${A[i]}

  cd ../
  
  mv resultados_ang${A[i]} resultados_esfera/resultados_ang${A[i]}/

  rm test_file.txt
done
