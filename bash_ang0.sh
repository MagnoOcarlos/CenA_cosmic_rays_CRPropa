#!/bin/sh
#PBS -M rma@ifi.unicamp.br
#PBS -m abe
#PBS -N ang0
#PBS -e esfera.err
#PBS -o esfera.out
#PBS -q auger
#PBS -l nodes=1:ppn=1




. /etc/profile.d/modules.sh

module load compiler/gcc-4.8.2
source /home/sw/intel/bin/compilervars.sh intel64
source /home/sw/intel/composer_xe_2015/mkl/bin/mklvars.sh intel64
. /home/sw/intel/impi/5.1.2.150/bin64/mpivars.sh
export INTEL_LICENSE_FILE=/opt/intel/composerxe-2011.0.084/licenses:/opt/intel/l
icenses:/home/cc/fandri/intel/licenses:/opt/intel/composer_xe_2011_sp1.6.233/lic
enses:/opt/intel/licenses:/home/cc/fandri/intel/licenses
export I_MPI_HYDRA_BOOTSTRAP=rsh
export I_MPI_DEVICE=rdssm



#Inicio do script

source /home/drc01/kemp/rma/CRPropa-Rafa/ExportMe



cd $dir
declare -a arrGeo

for file in *dados.*0*.txt
do
    arrGeo=(${arrGeo[*]} "$file")
done

for item in  "${arrGeo[@]}"
do
    /home/drc01/kemp/rma/CRPropa-Rafa/Python-3.8.2/build/bin/python3.8  $dir/geometria_esfera_healpix_2.py ${item} 0  file_eventos_chegaram0.txt file_eventos_cone0.txt

    cp file_eventos_chegaram0.txt  detec_${item}_ang0

    cp file_eventos_cone0.txt  resultados_${item}_cone_ang0

    rm file_eventos_cone0.txt
    rm file_eventos_chegaram0.txt
done


  awk '
    FNR>1 || NR==1
' detec*dados.*0*ang0 >resultados_ang0

  awk '
    FNR>1 || NR==1
' resultados*dados.*0*ang0 >resultados_cone_ang0

  mkdir resultados

  cd resultados/

  mkdir resultados_ang0

  cd ../

  mv resultados_ang0  resultados/resultados_ang0/

  mv resultados_cone_ang0 resultados/resultados_ang0/

  rm resultado*ang0
  rm detec*ang0

  sed -i '31d' $0
